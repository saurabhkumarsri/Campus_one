module SchoolAdmin
  class SubjectAssignmentsController < BaseController
    def index
      @assignments = ClassroomSubject.joins(:classroom, :subject)
                                       .where(classrooms: { school_id: current_user.school_id })
                                       .includes(:teacher)
                                       .order("classrooms.name, subjects.name")
    end

    def new
      @assignment = ClassroomSubject.new
      @classrooms = scope_query(Classroom).active
      @subjects = scope_query(Subject).active
      @teachers = scope_query(Teacher).active
    end

    def create
      @assignment = ClassroomSubject.new(assignment_params)
      if @assignment.save
        redirect_to school_admin_subject_assignments_path, notice: "Subject assigned successfully."
      else
        @classrooms = scope_query(Classroom).active
        @subjects = scope_query(Subject).active
        @teachers = scope_query(Teacher).active
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      @assignment = ClassroomSubject.joins(:classroom)
                                      .where(classrooms: { school_id: current_user.school_id })
                                      .find(params[:id])
      @assignment.destroy
      redirect_to school_admin_subject_assignments_path, notice: "Assignment removed."
    end

    private

    def assignment_params
      params.require(:classroom_subject).permit(:classroom_id, :subject_id, :teacher_id)
    end
  end
end
