json.array!(@purchases) do |purchase|
  json.extract! purchase, :id, :name, :item_id, :price, :qty
  json.url purchase_url(purchase, format: :json)
end
