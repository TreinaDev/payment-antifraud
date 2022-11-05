class HomeController < ApplicationController
  before_action :require_admin, only: %i[registered_users]

  def index; end

  def registered_users
    @users = User.all.sort_by(&:status)
  end
end
