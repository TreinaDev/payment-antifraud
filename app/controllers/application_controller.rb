class ApplicationController < ActionController::Base
  before_action :devise_parameter_sanitizer, if: :devise_controller?
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

  def devise_parameter_sanitizer
    if resource_class == User
      ParameterSanitizer.new(User, :user, params)
    else
      super
    end
  end

  def require_admin
    return redirect_to root_path, alert: t('no_access_granted') unless current_admin
  end

  def require_user
    return redirect_to root_path, alert: t('no_access_granted') unless current_user&.approved?
  end

  def return500
    redirect_to root_path, alert: t('controllers.application.internal_error')
  end
end
