module SchoolAdmin
  class ExamResultsController < BaseController
    include SchoolScope

    def index
      @exam = scope_query(Exam).find(params[:exam_id])
      @results = @exam.exam_results.includes(:student).order(marks_obtained: :desc)
    end

    def new
      @exam = scope_query(Exam).find(params[:exam_id])
      @result = @exam.exam_results.new
      load_students
    end

    def create
      @exam = scope_query(Exam).find(params[:exam_id])
      @result = @exam.exam_results.new(result_params)
      if @result.save
        redirect_to school_admin_exam_results_path(@exam), notice: "Result added."
      else
        load_students
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @exam = scope_query(Exam).find(params[:exam_id])
      @result = @exam.exam_results.find(params[:id])
    end

    def update
      @exam = scope_query(Exam).find(params[:exam_id])
      @result = @exam.exam_results.find(params[:id])
      if @result.update(result_params)
        redirect_to school_admin_exam_results_path(@exam), notice: "Result updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @exam = scope_query(Exam).find(params[:exam_id])
      @result = @exam.exam_results.find(params[:id])
      @result.destroy
      redirect_to school_admin_exam_results_path(@exam), notice: "Result deleted."
    end

    private

    def result_params
      params.require(:exam_result).permit(:student_id, :marks_obtained, :remarks)
    end

    def load_students
      @students = @exam.section.present? ? @exam.section.students : @exam.classroom.students
    end
  end
end
