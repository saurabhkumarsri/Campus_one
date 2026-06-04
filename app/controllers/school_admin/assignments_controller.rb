module SchoolAdmin
  class AssignmentsController < BaseController
    def index
      teacher = current_user.teacher
      if teacher
        @assignments = scope_query(Assignment).where(teacher_id: teacher.id).includes(:classroom, :subject).order(created_at: :desc)
      else
        @assignments = scope_query(Assignment).includes(:classroom, :subject, :teacher).order(created_at: :desc)
      end
    end

    def show
      @assignment = scope_query(Assignment).find(params[:id])
    end

    def new
      @assignment = scope_query(Assignment).new
    end

    def create
      @assignment = scope_query(Assignment).new(assignment_params)
      if @assignment.save
        redirect_to school_admin_assignments_path, notice: "Assignment created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @assignment = scope_query(Assignment).find(params[:id])
    end

    def update
      @assignment = scope_query(Assignment).find(params[:id])
      if @assignment.update(assignment_params)
        redirect_to school_admin_assignments_path, notice: "Assignment updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @assignment = scope_query(Assignment).find(params[:id])
      @assignment.destroy
      redirect_to school_admin_assignments_path, notice: "Assignment deleted."
    end

    def submissions
      @assignment = scope_query(Assignment).find(params[:id])
      @submissions = HomeworkSubmission.where(homework_id: @assignment.id).includes(:student)
    end

    def review_submission
      @submission = HomeworkSubmission.find(params[:id])
      if @submission.update(review_params)
        redirect_to submissions_school_admin_assignment_path(@submission.homework), notice: "Submission reviewed."
      else
        redirect_back fallback_location: school_admin_assignments_path, alert: "Review failed."
      end
    end

    private

    def assignment_params
      params.require(:assignment).permit(:classroom_id, :teacher_id, :subject_id, :title, :description, :due_date, :max_marks, :status)
    end

    def review_params
      params.require(:homework_submission).permit(:marks, :remarks, :status)
    end
  end
end
