class Design < ActiveRecord::Base
  has_one_attached :base_image
  has_one_attached :thumbnail
  has_many_attached :layer_images

  validates :name, presence: true
  validates :width, :height, presence: true, inclusion: { in: 64..4096 }
  validates :base_scale, :base_offset_x, :base_offset_y, presence: true

  def layer_image_for(layer_id)
    return nil unless layer_images.attached?

    layer_images.attachments.detect { |img| img.filename.to_s == layer_id.to_s }
  end
end
