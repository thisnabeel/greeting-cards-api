json.extract! formula, :id, :title, :position, :product_id, :created_at, :updated_at
json.materials formula.materials do |material|
    json.merge! material.attributes
end
json.url formula_url(formula, format: :json)
