class ApplicationController < ActionController::Base
  before_action :disable_repositories_link
  before_action :disable_owners_link

  private

  def disable_repositories_link
    @repositories_is_empty = Repository.first.nil?
  end

  def disable_owners_link
    @owners_is_empty = Owner.first.nil?
  end
end
