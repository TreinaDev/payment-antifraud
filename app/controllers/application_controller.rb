class ApplicationController < ActionController::Base
  private
  
  def authenticate!
    if !current_admin.nil?
      :authenticate_admin!
    elsif !current_user.nil?
      :authenticate_user!
    else
      flash[:alert] = t(:sign_in_to_enter)
      redirect_to root_path
    end
  end
end
