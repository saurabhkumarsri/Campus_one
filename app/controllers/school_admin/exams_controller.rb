module SchoolAdmin
  class ExamsController < BaseController
    include SchoolScope

    def index
      @exams = scope_query(Exam).includes(:classroom, :section, :subject).order(exam_date: :desc)
      @exams = @exams.where(classroom_id: params[:classroom_id]) if params[:classroom_id].present?
      @exams = @exams.where(exam_type: params[:exam_type]) if params[:exam_type].present?
    end

    def show
      @exam = scope_query(Exam).find(params[:id])
      @results = @exam.exam_results.includes(:student).order(marks_obtained: :desc)
    end

    def new
      @exam = Exam.new
      load_form_data
    end

    def create
      @exam = scope_query(Exam).new(exam_params)
      if @exam.save
        redirect_to school_admin_exams_path, notice: "Exam created successfully."
      else
        load_form_data
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @exam = scope_query(Exam).find(params[:id])
      load_form_data
    end

    def update
      @exam = scope_query(Exam).find(params[:id])
      if @exam.update(exam_params)
        redirect_to school_admin_exam_path(@exam), notice: "Exam updated successfully."
      else
        load_form_data
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @exam = scope_query(Exam).find(params[:id])
      @exam.destroy
      redirect_to school_admin_exams_path, notice: "Exam deleted."
    end

    def results
      @exam = scope_query(Exam).find(params[:id])
      @students = @exam.section.present? ? @exam.section.students : @exam.classroom.students
      @results = @exam.exam_results.index_by(&:student_id)
    end

    def publish_results
      @exam = scope_query(Exam).find(params[:id])
      @exam.exam_results.update_all(status: "published")
      @exam.update!(status: "completed")
      redirect_to school_admin_exam_path(@exam), notice: "Results published successfully."
    end

    def report_card
      @exam = scope_query(Exam).find(params[:id])
      @results = @exam.exam_results.where(status: "published").includes(:student)
      respond_to do |format|
        format.html
        format.pdf { render pdf: "report_card_#{@exam.id}" }
      end
    end

    def class_ranking
      @exam = scope_query(Exam).find(params[:id])
      @results = @exam.exam_results.where(status: "published").includes(:student).order(marks_obtained: :desc)
    end

    private

    def exam_params
      params.require(:exam).permit(:classroom_id, :section_id, :subject_id, :title, :exam_type, :exam_date, :start_time, :end_time, :max_marks, :pass_marks, :instructions)
    end

    def load_form_data
      @classrooms = scope_query(Classroom).order(:name)
      @sections = scope_query(Section).order(:name)
      @subjects = scope_query(Subject).order(:name)
    end
  end
end
