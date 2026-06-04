module StudentPortal
  class ExamsController < BaseController
    def index
      @exams = scope_query(Exam)
        .where(classroom_id: @student.classroom_id)
        .where("section_id IS NULL OR section_id = ?", @student.section_id)
        .order(exam_date: :desc)
    end

    def show
      @exam = scope_query(Exam).find(params[:id])
      @result = @exam.exam_results.find_by(student_id: @student.id)
    end
  end
end
