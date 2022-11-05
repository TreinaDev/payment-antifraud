class ApplicationController < ActionController::Base

  private

    def require_admin
      unless current_admin 
        return redirect_to root_path, notice: t('no_access_granted')
      end 
    end

end
