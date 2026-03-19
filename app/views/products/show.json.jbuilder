json.extract! @product, :id, :title, :description, :price, :minimum, :maximum, :image_url, :group_size, :tags, :category_id, :active

if @product.greeting_card
  json.greeting_card do
    card = @product.greeting_card
    json.id card.id
    json.product_id card.product_id
    json.title card.title
    json.front_scale card.front_scale
    json.front_offset_x card.front_offset_x
    json.front_offset_y card.front_offset_y
    json.inside_scale card.inside_scale
    json.inside_offset_x card.inside_offset_x
    json.inside_offset_y card.inside_offset_y
    json.sheet_format card.sheet_format
    json.fold_ratio_front card.fold_ratio_front
    json.fold_ratio_inside card.fold_ratio_inside
    json.front_image_url(card.front_image.attached? ? rails_storage_proxy_url(card.front_image, only_path: false) : nil)
    json.inside_image_url(card.inside_image.attached? ? rails_storage_proxy_url(card.inside_image, only_path: false) : nil)
    json.front_layers card.front_layers.presence || []
    json.inside_layers card.inside_layers.presence || []
  end
end
json.customizations @product.customizations do |customization|
    json.merge! customization.attributes
end
json.category @product.category
