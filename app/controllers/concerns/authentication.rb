module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_login
    helper_method :current_user
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def require_login
    unless current_user
      redirect_to login_path, alert: "Please log in to continue."
    end
  end

  def require_super_admin
    unless current_user&.super_admin?
      redirect_to root_path, alert: "Access denied."
    end
  end

  def require_school_admin
    unless current_user&.school_admin?
      redirect_to root_path, alert: "Access denied."
    end
  end

  def require_teacher
    unless current_user&.teacher?
      redirect_to root_path, alert: "Access denied."
    end
  end

  def require_student
    unless current_user&.student?
      redirect_to root_path, alert: "Access denied."
    end
  end
end
