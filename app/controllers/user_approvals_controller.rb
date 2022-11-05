class UserApprovalsController < ApplicationController
  def new
    @user = User.find params[:user_id]
    @user_approval = UserApproval.new
  end

  def create; end
end
