class UserApprovalsController < ApplicationController
  before_action :require_admin
  before_action :set_user

  def new
    @user_approval = UserApproval.new
  end

  def create
    @user_approval = UserApproval.new(new_approval_params)
    @user_approval.user = @user

    if @user_approval.save
      @user_approval.status ? @user.approved! : @user.refused!
      message = @user.approved? ? 'Usuário aprovado com sucesso.' : 'Usuário reprovado com sucesso.'
      return redirect_to registered_users_home_index_url, notice: message
    end
    render :new
  end

  private

  def new_approval_params
    params.require(:user_approval).permit(:status, :refusal)
  end

  def set_user
    @user = User.find params[:user_id]
  end
end
