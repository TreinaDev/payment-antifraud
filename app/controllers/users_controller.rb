class UsersController < ApplicationController
  before_action :require_admin

  def index
    @users = User.all.sort_by(&:status)
  end
end
