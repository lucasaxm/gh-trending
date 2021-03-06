class TrendingController < ApplicationController
  before_action :setup_octokit, only: :search

  # GET /
  def index; end

  # GET /search
  # GET /search.json
  def search
    query = language_params
    params = query.split(',').map(&:strip)
    @repositories = {}
    params.each do |language|
      logger.info "language received: #{language}"
      results = @client.search_repos("language: #{language}", sort: 'stars', order: 'desc')
      logger.info "#{results.total_count} #{'records'.pluralize(results.total_count)} found"
      @repositories[language] = find_or_create_repository_list(results.items[0..9])
    end
  end

  private

  def find_or_create_repository_list(gh_repository_list)
    return nil if gh_repository_list.nil?
    repository_list = []
    gh_repository_list.each do |r|
      repo = find_or_create_repository(r)
      repository_list << repo.clone unless repo.nil?
    end
    repository_list
  end

  def find_or_create_repository(gh_repository)
    return nil if gh_repository.nil?
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
    repo
  end

  def fetch_language(gh_language)
    return nil if gh_language.nil?
    lang_downcased = gh_language.downcase
    lang_model = Language.find_by_name(lang_downcased)
    if lang_model.nil?
      lang_model = Language.new
      lang_model.name = lang_downcased
      lang_model.errors.full_messages
      lang_model.save
    end
    lang_model
  end

  def fetch_owner(gh_owner)
    return nil if gh_owner.nil?
    begin
      owner = Owner.find(gh_owner.id)
    rescue ActiveRecord::RecordNotFound
      owner = Owner.new
      owner.id = gh_owner.id
      owner.nodeid = gh_owner.node_id
      owner.login = gh_owner.login
      owner.type = fetch_type(gh_owner)
      owner.avatar_url = gh_owner.avatar_url
      owner.html_url = gh_owner.html_url
      owner.errors.full_messages
      owner.save
    end
    owner
  end

  def fetch_type(owner_type)
    return nil if owner_type.nil?
    type_downcased = owner_type.type.downcase
    type = Type.find_by_name(type_downcased)
    if type.nil?
      type = Type.new
      type.name = type_downcased
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
    params.require(:q)
  end
end

