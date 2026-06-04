module SchoolAdmin
  class MyClassesController < BaseController
    def index
      teacher = current_user.teacher
      return redirect_to(root_path, alert: "Teacher profile not found.") unless teacher

      @classroom_subjects = teacher.classroom_subjects.includes(:classroom, :subject)
    end
  end
end
