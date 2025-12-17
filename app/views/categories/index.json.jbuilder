json.array!(@categories) do |category|
  json.extract! category, :id, :position, :title
  
  json.products category.products.includes(formulas: :materials) do |product|
    json.merge! product.attributes

    json.formulas product.formulas do |formula|
      json.merge! formula.attributes

      json.materials formula.materials do |material|
        json.merge! material.attributes
      end
    end

    json.customizations product.customizations do |customization|
      json.merge! customization.attributes
    end
  end
  json.url category_url(category, format: :json)
end
