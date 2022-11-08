class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::QueryCanceled, with: :return500

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

  def require_admin
    return redirect_to root_path, notice: t('no_access_granted') unless current_admin
  end

  def return500
    redirect_to root_path, notice: t('controllers.application.internal_error')
  end
end
