module StudentPortal
  class CoursesController < BaseController
    def index
      @enrollments = @student.course_enrollments.includes(:course).order(created_at: :desc)
      @courses = scope_query(Course).for_classroom(@student.classroom_id).active.where.not(id: @enrollments.pluck(:course_id))
    end

    def show
      @course = scope_query(Course).includes(chapters: { topics: :quizzes }).find(params[:id])
      @enrollment = @student.course_enrollments.find_by(course_id: @course.id)
    end

    def chapters
      @course = scope_query(Course).includes(chapters: { topics: :quizzes }).find(params[:id])
      @enrollment = @student.course_enrollments.find_by(course_id: @course.id)
    end

    def quiz
      @course = scope_query(Course).find(params[:id])
      @quiz = Quiz.find(params[:quiz_id])
      @attempt = @quiz.quiz_attempts.find_or_initialize_by(student_id: @student.id)
      @questions = @quiz.quiz_questions
    end

    def submit_quiz
      @course = scope_query(Course).find(params[:id])
      @quiz = Quiz.find(params[:quiz_id])
      @attempt = @quiz.quiz_attempts.find_or_initialize_by(student_id: @student.id)
      @attempt.assign_attributes(answers: params[:answers] || {}, status: "completed")
      @attempt.save!
      @attempt.complete!
      redirect_to student_portal_course_path(@course), notice: "Quiz submitted! Score: #{@attempt.score}"
    rescue StandardError => e
      redirect_to student_portal_course_path(@course), alert: "Error: #{e.message}"
    end
  end
end
