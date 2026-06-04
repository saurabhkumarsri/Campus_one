module SchoolAdmin
  class CourseEnrollmentsController < BaseController
    include SchoolScope

    def index
      @course = scope_query(Course).find(params[:course_id])
      @enrollments = @course.course_enrollments.includes(:student).order(created_at: :desc)
      @unenrolled = scope_query(Student).active.where.not(id: @course.enrolled_students.pluck(:id))
    end

    def create
      @course = scope_query(Course).find(params[:course_id])
      @enrollment = @course.course_enrollments.new(enrollment_params)
      if @enrollment.save
        redirect_to school_admin_course_path(@course), notice: "Student enrolled."
      else
        redirect_to school_admin_course_path(@course), alert: "Enrollment failed."
      end
    end

    def destroy
      @course = scope_query(Course).find(params[:course_id])
      @enrollment = @course.course_enrollments.find(params[:id])
      @enrollment.destroy
      redirect_to school_admin_course_path(@course), notice: "Student unenrolled."
    end

    private

    def enrollment_params
      params.require(:course_enrollment).permit(:student_id)
    end
  end
end
