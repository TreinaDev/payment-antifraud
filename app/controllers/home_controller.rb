class HomeController < ApplicationController
  def index; end

  def registered_users
    @pending_users = User.pending 
    @approved_users = User.approved
  end
end
