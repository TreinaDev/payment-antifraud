class HomeController < ApplicationController
  def index; end

  def registered_users
    @users = User.all.sort_by(&:status)
  end
end
