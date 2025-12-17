json.extract! @product, :id, :title, :description, :price, :minimum, :maximum, :image_url, :group_size, :tags, :category_id, :active
json.customizations @product.customizations do |customization|
    json.merge! customization.attributes
end
json.category @product.category
