module SchoolAdmin
  class BaseController < ApplicationController
    before_action :require_school_admin_or_teacher
    before_action :check_school_subscription
    before_action :rewrite_teacher_path, if: -> { current_user&.teacher? }

    private

    def require_school_admin_or_teacher
      unless current_user&.school_admin? || current_user&.teacher?
        redirect_to root_path, alert: "Access denied."
      end
    end

    def check_school_subscription
      return if %w[subscriptions payments].include?(controller_name)
      return unless current_user&.school_admin?

      school = current_user.school
      if school&.subscription_expired?
        redirect_to school_admin_subscriptions_path, alert: "Your subscription has expired. Please renew to continue."
      end
    end

    # Redirect teachers from /school_admin/* to /teacher/* when the route exists
    def rewrite_teacher_path
      return unless request.get?
      return unless request.path.start_with?("/school_admin/")

      teacher_target = request.path.sub(%r{\A/school_admin}, "/teacher")
      begin
        Rails.application.routes.recognize_path(teacher_target, method: :get)
        redirect_to teacher_target + (request.query_string.present? ? "?#{request.query_string}" : "") and return
      rescue ActionController::RoutingError
        # no equivalent teacher route — stay on school_admin path
      end
    end

    # Rewrite /school_admin/* redirects to /teacher/* for teachers
    def redirect_to(options = {}, response_status = {})
      if current_user&.teacher? && options.is_a?(String) && options.start_with?("/school_admin/")
        options = options.sub(%r{\A/school_admin/}, "/teacher/")
      end
      super(options, response_status)
    end
  end
end
