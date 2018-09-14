json.extract! owner, :id, :nodeid, :login, :name, :type_id, :avatar_url, :html_url, :created_at, :updated_at
json.url owner_url(owner, format: :json)
