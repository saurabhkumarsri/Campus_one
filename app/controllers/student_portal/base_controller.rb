module StudentPortal
  class BaseController < ApplicationController
    before_action :require_student
    before_action :set_student
    before_action :set_current_school

    private

    def set_student
      @student = current_user.student
      unless @student
        redirect_to root_path, alert: "Student profile not found."
      end
    end

    def set_current_school
      @current_school = @student.school
    end

    def scope_query(relation)
      relation.where(school_id: @current_school.id)
    end
  end
end
