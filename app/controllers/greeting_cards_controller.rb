class GreetingCardsController < ApplicationController
  LAYER_SCALAR_KEYS = %w[
    id type xRatio yRatio widthRatio heightRatio radiusRatio
    opacity text fontSizeRatio textColor fontFamily rotation
    strokeEnabled strokeColor strokeWidthRatio
    backgroundEnabled backgroundColor backgroundOpacity
    backgroundStrokeColor backgroundStrokeWidthRatio
    backgroundRadiusRatio backgroundPaddingXRatio backgroundPaddingYRatio
  ].freeze

  before_action :set_product, only: [:show, :create, :update]
  before_action :set_greeting_card, only: [:show, :update]

  # This endpoint is called from the Svelte app on a different port,
  # so we skip CSRF origin checks and authenticity verification.
  skip_forgery_protection

  def show
    if @greeting_card
      render json: serialize_greeting_card(@greeting_card)
    else
      render json: {}, status: :not_found
    end
  end

  def create
    @greeting_card ||= @product.greeting_card
    @greeting_card ||= @product.build_greeting_card

    @greeting_card.assign_attributes(greeting_card_params)

    if @greeting_card.save
      render json: serialize_greeting_card(@greeting_card), status: :created
    else
      render json: { errors: @greeting_card.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @greeting_card.update(greeting_card_params)
      render json: serialize_greeting_card(@greeting_card)
    else
      render json: { errors: @greeting_card.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Returns greeting cards of the same `sheet_format` that already have inside layers.
  # Used by the Card Studio "Import" modal to duplicate layers into the current card.
  def import_candidates
    sheet_format = params[:sheet_format] || 'letter'

    cards = GreetingCard
      .where(sheet_format: sheet_format)
      .where('COALESCE(jsonb_array_length(inside_layers), 0) > 0')
      .includes(:product)
      .order(created_at: :desc)
      .limit(30)

    render json: cards.map do |card|
      inside = card.inside_layers.presence || []
      {
        id: card.id,
        title: card.title,
        product_title: card.product&.title,
        sheet_format: card.sheet_format,
        inside_layers_count: inside.is_a?(Array) ? inside.length : 0,
        inside_layers: inside
      }
    end
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_greeting_card
    @greeting_card = @product.greeting_card
  end

  def greeting_card_params
    raw = params.require(:greeting_card)
    permitted = raw.permit(
      :title,
      :sheet_format,
      :front_scale,
      :front_offset_x,
      :front_offset_y,
      :inside_scale,
      :inside_offset_x,
      :inside_offset_y,
      :fold_ratio_front,
      :fold_ratio_inside,
      :front_image,
      :inside_image
    )

    attrs = permitted.to_h
    unsafe = raw.to_unsafe_h

    if unsafe.key?('front_layers') || unsafe.key?(:front_layers)
      attrs[:front_layers] = normalize_layers_param(unsafe['front_layers'] || unsafe[:front_layers])
    end

    if unsafe.key?('inside_layers') || unsafe.key?(:inside_layers)
      attrs[:inside_layers] = normalize_layers_param(unsafe['inside_layers'] || unsafe[:inside_layers])
    end

    attrs
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
      h.slice(*LAYER_SCALAR_KEYS)
    end
  rescue JSON::ParserError, TypeError
    []
  end

  def serialize_greeting_card(card)
    {
      id: card.id,
      product_id: card.product_id,
      title: card.title,
      sheet_format: card.sheet_format,
      front_scale: card.front_scale,
      front_offset_x: card.front_offset_x,
      front_offset_y: card.front_offset_y,
      inside_scale: card.inside_scale,
      inside_offset_x: card.inside_offset_x,
      inside_offset_y: card.inside_offset_y,
      fold_ratio_front: card.fold_ratio_front,
      fold_ratio_inside: card.fold_ratio_inside,
      front_image_url: card.front_image.attached? ? rails_storage_proxy_url(card.front_image, only_path: false) : nil,
      inside_image_url: card.inside_image.attached? ? rails_storage_proxy_url(card.inside_image, only_path: false) : nil,
      front_layers: card.front_layers.presence || [],
      inside_layers: card.inside_layers.presence || []
    }
  end
end

