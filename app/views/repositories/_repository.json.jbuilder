json.extract! repository, :id, :nodeid, :name, :full_name, :owner_id, :html_url, :description, :stargazers_count, :created_at, :updated_at
json.url repository_url(repository, format: :json)
