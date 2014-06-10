json.array!(@docs_histories) do |docs_history|
  json.extract! docs_history, :id, :docs_id, :description, :prev_histroy_id, :next_histroy_id, :by_user_id, :by_user_email
  json.url docs_history_url(docs_history, format: :json)
end
