class TrendingController < ApplicationController
  before_action :setup_octokit, only: :search

  # GET /trending
  # GET /trending.json
  def index; end

  # GET /trending
  # GET /trending.json
  def search
    languages = language_params
    languages.each do |lang|
      results = @client.search_repos("language: #{lang}", sort: 'stars', order: 'desc')

      first10 = results.items[0..9]

      ret = []
      repo = nil
      first10.each do |r|
        begin
          repo = Repository.find(r.id)
        rescue ActiveRecord::RecordNotFound
          repo = Repository.new
          repo.id = r.id
          repo.nodeid = r.node_id
          repo.name = r.name
          repo.full_name = r.full_name
          repo.owner = fetch_owner(r.owner)
          repo.html_url = r.html_url
          repo.description = r.description
          repo.stargazers_count = r.stargazers_count
          repo.created_at = r.created_at
          repo.updated_at = r.updated_at
          repo.language = fetch_language(r.language)
          repo.errors.full_messages
          repo.save
        end
      end

      ret << repo.clone unless repo.nil?

      ap lang
      ap results.total_count
    end
  end

  private

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
    params.require(%i[lang1 lang2 lang3 lang4 lang5])
  end
end

