class ApplicationController < ActionController::Base
  before_action :devise_parameter_sanitizer, if: :devise_controller?
  rescue_from ActiveRecord::QueryCanceled, with: :return500

  private

  def authenticate!
    return if admin_signed_in?

    require_user
  end

  def devise_parameter_sanitizer
    if resource_class == User
      ParameterSanitizer.new(User, :user, params)
    else
      super
    end
  end

  def page_params(posts_per_page)
    params.permit(:page).merge(per_page: posts_per_page)
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
