json.array!(@items) do |item|
  json.extract! item, :id, :description, :price, :qoh, :merchant_id
  json.url item_url(item, format: :json)
end
