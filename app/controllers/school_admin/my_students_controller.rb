module SchoolAdmin
  class MyStudentsController < BaseController
    def index
      teacher = current_user.teacher
      return redirect_to(root_path, alert: "Teacher profile not found.") unless teacher

      classroom_ids = teacher.classroom_subjects.pluck(:classroom_id).uniq
      @students = Student.where(classroom_id: classroom_ids)
                         .includes(:classroom, :section, :student_attendances, :exam_results)
                         .order(:roll_no)
    end
  end
end
