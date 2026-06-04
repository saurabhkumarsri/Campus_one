class HomeController < ApplicationController
  skip_before_action :require_login, only: [:landing]

  def landing
    if current_user&.super_admin?
      redirect_to super_admin_root_path
    elsif current_user&.school_admin?
      redirect_to school_admin_root_path
    elsif current_user&.teacher?
      redirect_to school_admin_teacher_dashboard_path
    elsif current_user&.student?
      redirect_to student_portal_root_path
    end
  end
end
