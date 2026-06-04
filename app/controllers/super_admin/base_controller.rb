module SuperAdmin
  class BaseController < ApplicationController
    before_action :require_login
    before_action :require_super_admin

    private

    def require_login
      unless current_user
        redirect_to super_admin_login_path, alert: "Please log in to continue."
      end
    end

    def require_super_admin
      unless current_user&.super_admin?
        redirect_to super_admin_login_path, alert: "Super admin access required."
      end
    end
  end
end
