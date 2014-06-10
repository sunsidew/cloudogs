json.array!(@docs) do |doc|
  json.extract! doc, :id, :id, :title, :filename, :now_history_id, :owner_user_id
  json.url doc_url(doc, format: :json)
end
