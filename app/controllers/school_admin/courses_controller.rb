module SchoolAdmin
  class CoursesController < BaseController
    include SchoolScope

    def index
      @courses = scope_query(Course).includes(:classroom, :subject, :teacher).order(:title)
    end

    def show
      @course = scope_query(Course).includes(chapters: { topics: :quizzes }).find(params[:id])
      @enrollments = @course.course_enrollments.includes(:student).order(created_at: :desc)
    end

    def new
      @course = Course.new
      load_form_data
    end

    def create
      @course = scope_query(Course).new(course_params)
      if @course.save
        redirect_to school_admin_courses_path, notice: "Course created."
      else
        load_form_data
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @course = scope_query(Course).find(params[:id])
      load_form_data
    end

    def update
      @course = scope_query(Course).find(params[:id])
      if @course.update(course_params)
        redirect_to school_admin_course_path(@course), notice: "Course updated."
      else
        load_form_data
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @course = scope_query(Course).find(params[:id])
      @course.destroy
      redirect_to school_admin_courses_path, notice: "Course deleted."
    end

    private

    def course_params
      params.require(:course).permit(:title, :description, :classroom_id, :subject_id, :teacher_id, :status)
    end

    def load_form_data
      @classrooms = scope_query(Classroom).order(:name)
      @subjects = scope_query(Subject).order(:name)
      @teachers = scope_query(Teacher).active.order(:name)
    end
  end
end
