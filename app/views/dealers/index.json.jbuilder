json.array!(@dealers) do |dealer|
  json.extract! dealer, :id, :name, :path, :status
  json.url dealer_url(dealer, format: :json)
end
