json.data(@products) do |product|
  json.extract! product, :id, :name, :content, :price, :category, :quantity, :created_at, :updated_at, :picture
end
 