module SchoolAdmin
  class BaseController < ApplicationController
    before_action :require_school_admin
    before_action :check_school_subscription

    private

    def check_school_subscription
      return if %w[subscriptions payments].include?(controller_name)
      return unless current_user&.school_admin?

      school = current_user.school
      if school&.subscription_expired?
        redirect_to school_admin_subscriptions_path, alert: "Your subscription has expired. Please renew to continue."
      end
    end
  end
end
