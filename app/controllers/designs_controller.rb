class DesignsController < ApplicationController
  LAYER_SCALAR_KEYS = %w[
    id type name parentId xRatio yRatio widthRatio heightRatio radiusRatio opacity
    text fontSizeRatio textColor fontFamily rotation respectBounds
    lineHeight padding paddingRatio letterSpacing letterSpacingRatio
    strokeEnabled strokeColor strokeWidthRatio
    backgroundEnabled backgroundColor backgroundOpacity
    backgroundStrokeColor backgroundStrokeWidthRatio backgroundRadiusRatio
    backgroundPaddingXRatio backgroundPaddingYRatio
    runs
  ].freeze

  RUN_KEYS = %w[
    text fontSizeRatio fontFamily color letterSpacingRatio fontSize letterSpacing textColor
  ].freeze

  before_action :set_design, only: %i[show update destroy duplicate]

  skip_forgery_protection

  def index
    designs = Design.order(updated_at: :desc).limit(100)
    render json: designs.map { |d| serialize_design_summary(d) }
  end

  def show
    render json: serialize_design(@design)
  end

  def create
    @design = Design.new(design_attrs)
    attach_uploads(@design)

    if @design.save
      render json: serialize_design(@design), status: :created
    else
      render json: { errors: @design.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @design.assign_attributes(design_attrs)
    attach_uploads(@design)

    if @design.save
      render json: serialize_design(@design)
    else
      render json: { errors: @design.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @design.destroy!
    head :no_content
  end

  def duplicate
    copy = Design.new(
      name: "#{@design.name} (copy)",
      width: @design.width,
      height: @design.height,
      base_scale: @design.base_scale,
      base_offset_x: @design.base_offset_x,
      base_offset_y: @design.base_offset_y,
      layers: deep_copy_layers(@design.layers)
    )

    if copy.save
      copy_attachments!(@design, copy)
      render json: serialize_design(copy.reload), status: :created
    else
      render json: { errors: copy.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_design
    @design = Design.find(params[:id])
  end

  def design_attrs
    raw = params.require(:design)
    permitted = raw.permit(
      :name,
      :width,
      :height,
      :base_scale,
      :base_offset_x,
      :base_offset_y
    )

    attrs = permitted.to_h
    # Width/height locked after create
    if action_name == 'update'
      attrs.delete('width')
      attrs.delete('height')
      attrs.delete(:width)
      attrs.delete(:height)
    end

    unsafe = raw.to_unsafe_h
    if unsafe.key?('layers') || unsafe.key?(:layers)
      attrs[:layers] = normalize_layers_param(unsafe['layers'] || unsafe[:layers])
    end

    attrs
  end

  def attach_uploads(design)
    raw = params[:design]
    return unless raw

    design.base_image.attach(raw[:base_image]) if raw[:base_image].present?
    design.thumbnail.attach(raw[:thumbnail]) if raw[:thumbnail].present?

    layer_images = raw[:layer_images]
    return if layer_images.blank?

    entries =
      case layer_images
      when ActionController::Parameters
        layer_images.to_unsafe_h
      when Hash
        layer_images
      else
        {}
      end

    entries.each do |layer_id, file|
      next if file.blank?
      next unless file.respond_to?(:tempfile) || file.respond_to?(:read)

      existing = design.persisted? ? design.layer_image_for(layer_id) : nil
      existing&.purge

      blob = ActiveStorage::Blob.create_and_upload!(
        io: file.respond_to?(:open) ? file.open : file,
        filename: layer_id.to_s,
        content_type: file.respond_to?(:content_type) ? file.content_type : 'image/png'
      )
      design.layer_images.attach(blob)
    end
  end

  def normalize_layers_param(value)
    return [] if value.blank?

    parsed =
      case value
      when String
        JSON.parse(value)
      when Array
        value
      else
        []
      end

    Array(parsed).filter_map do |item|
      next unless item.is_a?(Hash) || item.is_a?(ActionController::Parameters)

      h = item.is_a?(ActionController::Parameters) ? item.to_unsafe_h : item
      h = h.transform_keys(&:to_s) if h.is_a?(Hash)
      out = h.slice(*LAYER_SCALAR_KEYS)
      if out['runs'].is_a?(Array)
        out['runs'] = out['runs'].filter_map do |run|
          next unless run.is_a?(Hash) || run.is_a?(ActionController::Parameters)

          rh = run.is_a?(ActionController::Parameters) ? run.to_unsafe_h : run
          rh = rh.transform_keys(&:to_s)
          rh.slice(*RUN_KEYS)
        end
      end
      out['parentId'] = out['parentId'].presence
      out
    end
  rescue JSON::ParserError, TypeError
    []
  end

  def deep_copy_layers(layers)
    id_map = {}
    Array(layers).each do |layer|
      h = layer.is_a?(Hash) ? layer : {}
      h = h.transform_keys(&:to_s)
      next if h['id'].blank?

      id_map[h['id'].to_s] = "layer-#{SecureRandom.hex(6)}"
    end

    Array(layers).map do |layer|
      h = layer.is_a?(Hash) ? layer.deep_dup : {}
      h = h.transform_keys(&:to_s)
      old_id = h['id'].to_s
      h['id'] = id_map[old_id] || "layer-#{SecureRandom.hex(6)}"
      if h['parentId'].present?
        h['parentId'] = id_map[h['parentId'].to_s]
      end
      if h['runs'].is_a?(Array)
        h['runs'] = h['runs'].filter_map do |run|
          next unless run.is_a?(Hash)

          run.transform_keys(&:to_s).slice(*RUN_KEYS)
        end
      end
      h.slice(*LAYER_SCALAR_KEYS)
    end
  end

  def copy_attachments!(source, target)
    if source.base_image.attached?
      target.base_image.attach(source.base_image.blob)
    end
    if source.thumbnail.attached?
      target.thumbnail.attach(source.thumbnail.blob)
    end

    return unless source.layer_images.attached?

    source_image_layers = Array(source.layers).select { |l| l.is_a?(Hash) && l['type'] == 'image' }
    target_image_layers = Array(target.layers).select { |l| l.is_a?(Hash) && l['type'] == 'image' }

    source_image_layers.each_with_index do |src_layer, idx|
      old_id = src_layer['id'].to_s
      new_id = target_image_layers[idx]&.dig('id')&.to_s
      next if new_id.blank?

      attachment = source.layer_image_for(old_id)
      next unless attachment

      target.layer_images.attach(
        io: StringIO.new(attachment.download),
        filename: new_id,
        content_type: attachment.content_type
      )
    end
  end

  def serialize_design_summary(design)
    {
      id: design.id,
      name: design.name,
      width: design.width,
      height: design.height,
      updated_at: design.updated_at,
      thumbnail_url: attachment_url(design.thumbnail)
    }
  end

  def serialize_design(design)
    layers = Array(design.layers).map do |layer|
      h = layer.is_a?(Hash) ? layer.transform_keys(&:to_s) : {}
      if h['type'] == 'image' && h['id'].present?
        img = design.layer_image_for(h['id'])
        h['src'] = attachment_url(img) if img
      end
      h
    end

    {
      id: design.id,
      name: design.name,
      width: design.width,
      height: design.height,
      base_scale: design.base_scale,
      base_offset_x: design.base_offset_x,
      base_offset_y: design.base_offset_y,
      layers: layers,
      base_image_url: attachment_url(design.base_image),
      thumbnail_url: attachment_url(design.thumbnail),
      updated_at: design.updated_at
    }
  end

  def attachment_url(attachable)
    return nil if attachable.nil?

    if attachable.respond_to?(:attached?)
      return nil unless attachable.attached?

      rails_storage_proxy_url(attachable, only_path: false)
    elsif attachable.respond_to?(:blob)
      rails_storage_proxy_url(attachable, only_path: false)
    end
  end
end
