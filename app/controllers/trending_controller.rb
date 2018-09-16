class TrendingController < ApplicationController
  before_action :setup_octokit, only: :search

  # GET /
  def index; end

  # GET /search
  # GET /search.json
  def search
    languages = language_params
    @repositories = {}
    languages.each do |lang|
      results = @client.search_repos("language: #{lang}", sort: 'stars', order: 'desc')
      @repositories[lang] = find_or_create_repository_list(results.items[0..9])
      ap lang
      ap results.total_count
    end
  end

  private

  def find_or_create_repository_list(gh_repository_list)
    repository_list = []
    gh_repository_list.each do |r|
      repo = find_or_create_repository(r)
      repository_list << repo.clone unless repo.nil?
    end
    repository_list
  end

  def find_or_create_repository(gh_repository)
    begin
      repo = Repository.find(gh_repository.id)
    rescue ActiveRecord::RecordNotFound
      repo = Repository.new
      repo.id = gh_repository.id
      repo.nodeid = gh_repository.node_id
      repo.name = gh_repository.name
      repo.full_name = gh_repository.full_name
      repo.owner = fetch_owner(gh_repository.owner)
      repo.html_url = gh_repository.html_url
      repo.description = gh_repository.description
      repo.stargazers_count = gh_repository.stargazers_count
      repo.created_at = gh_repository.created_at
      repo.updated_at = gh_repository.updated_at
      repo.language = fetch_language(gh_repository.language)
      repo.errors.full_messages
      repo.save
    end
    ap repo.class
    repo
  end

  def fetch_language(gh_language)
    begin
      lang_model = Language.find_by_name(gh_language.downcase) unless gh_language.nil?
    rescue ActiveRecord::RecordNotFound
      lang_model = Language.new
      lang_model.name = gh_language.downcase
      lang_model.errors.full_messages
      lang_model.save
    end
    lang_model
  end

  def fetch_owner(gh_owner)
    begin
      owner = Owner.find(gh_owner.id)
    rescue ActiveRecord::RecordNotFound
      owner = Owner.new
      owner.id = gh_owner.id
      owner.nodeid = gh_owner.node_id
      owner.login = gh_owner.login
      owner.name = gh_owner.name
      owner.type = fetch_type(gh_owner)
      owner.avatar_url = gh_owner.avatar_url
      owner.html_url = gh_owner.html_url
      owner.errors.full_messages
      owner.save
    end
    owner
  end

  def fetch_type(owner_type)
    begin
      type = Type.find_by_name(owner_type.type)
    rescue ActiveRecord::RecordNotFound
      type = Type.new
      type.name = owner_type.type
      type.errors.full_messages
      type.save
    end
    type
  end

  def setup_octokit
    @client = Octokit::Client.new
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def language_params
    params.permit(%i[lang1 lang2 lang3 lang4 lang5])
  end
end

