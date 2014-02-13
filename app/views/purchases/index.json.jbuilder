json.array!(@purchases) do |purchase|
  json.extract! purchase, :id, :name, :description, :price, :qty, :merchant_address, :merchant_name
  json.url purchase_url(purchase, format: :json)
end
