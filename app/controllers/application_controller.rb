class ApplicationController < ActionController::Base
  private

  def require_admin
    return redirect_to root_path, notice: t('no_access_granted') unless current_admin
  end
end
