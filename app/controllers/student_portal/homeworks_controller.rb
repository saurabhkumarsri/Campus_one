module StudentPortal
  class HomeworksController < BaseController
    def index
      @homeworks = scope_query(Homework)
        .for_classroom(@student.classroom_id)
        .where("section_id IS NULL OR section_id = ?", @student.section_id)
        .active
        .order(due_date: :asc)
    end

    def show
      @homework = scope_query(Homework).find(params[:id])
      @submission = @homework.homework_submissions.find_or_initialize_by(student_id: @student.id)
    end

    def submit
      @homework = scope_query(Homework).find(params[:id])
      @submission = @homework.homework_submissions.find_or_initialize_by(student_id: @student.id)
      @submission.assign_attributes(submission_params)
      @submission.submitted_at = Time.current
      @submission.status = @homework.due_date < Date.today ? "late" : "submitted"

      if @submission.save
        redirect_to student_portal_homeworks_path, notice: "Homework submitted successfully."
      else
        redirect_to student_portal_homework_path(@homework), alert: "Failed to submit."
      end
    end

    private

    def submission_params
      params.require(:homework_submission).permit(:submission_text, attachments: [])
    end
  end
end
