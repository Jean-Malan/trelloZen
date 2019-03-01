json.extract! list, :id, :name, :closed, :idnboard, :pos, :subscribed, :softlimit, :created_at, :updated_at
json.url list_url(list, format: :json)
