class ApplicationController < ActionController::Base
  before_action :disable_repositories_link

  private

  def disable_repositories_link
    @repositories_is_empty = Repository.first.nil?
  end

end
