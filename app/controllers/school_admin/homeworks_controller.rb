module SchoolAdmin
  class HomeworksController < BaseController
    include SchoolScope

    def index
      @homeworks = scope_query(Homework).includes(:classroom, :section, :subject, :teacher).order(created_at: :desc)
      @homeworks = @homeworks.where(classroom_id: params[:classroom_id]) if params[:classroom_id].present?
      @homeworks = @homeworks.where(teacher_id: params[:teacher_id]) if params[:teacher_id].present?
    end

    def show
      @homework = scope_query(Homework).find(params[:id])
      @stats = @homework.submission_stats
      @submissions = @homework.homework_submissions.includes(:student).order(submitted_at: :desc)
    end

    def new
      @homework = Homework.new
      load_form_data
    end

    def create
      @homework = scope_query(Homework).new(homework_params)
      if @homework.save
        redirect_to school_admin_homeworks_path, notice: "Homework assigned successfully."
      else
        load_form_data
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @homework = scope_query(Homework).find(params[:id])
      load_form_data
    end

    def update
      @homework = scope_query(Homework).find(params[:id])
      if @homework.update(homework_params)
        redirect_to school_admin_homework_path(@homework), notice: "Homework updated."
      else
        load_form_data
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @homework = scope_query(Homework).find(params[:id])
      @homework.destroy
      redirect_to school_admin_homeworks_path, notice: "Homework deleted."
    end

    def submissions
      @homework = scope_query(Homework).find(params[:id])
      @submissions = @homework.homework_submissions.includes(:student).order(submitted_at: :desc)
    end

    def review_submission
      @homework = scope_query(Homework).find(params[:id])
      @submission = @homework.homework_submissions.find(params[:submission_id] || params[:homework_submission_id])
      if @submission.mark_as_reviewed!(params[:grade], params[:teacher_remarks])
        redirect_to school_admin_homework_path(@homework), notice: "Submission reviewed."
      else
        redirect_to school_admin_homework_path(@homework), alert: "Failed to review."
      end
    end

    private

    def homework_params
      params.require(:homework).permit(:teacher_id, :classroom_id, :section_id, :subject_id, :title, :description, :due_date, attachments: [])
    end

    def load_form_data
      @teachers = scope_query(Teacher).active.order(:name)
      @classrooms = scope_query(Classroom).order(:name)
      @sections = scope_query(Section).order(:name)
      @subjects = scope_query(Subject).order(:name)
    end
  end
end
