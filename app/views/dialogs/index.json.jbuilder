json.array!(@dialogs) do |dialog|
  json.extract! dialog, :id, :docs_id, :filename
  json.url dialog_url(dialog, format: :json)
end
