module SchoolAdmin
  class QuizzesController < BaseController
    include SchoolScope

    def create
      @course = scope_query(Course).find(params[:course_id])
      @chapter = @course.chapters.find(params[:chapter_id])
      @topic = @chapter.topics.find(params[:topic_id])
      @quiz = @topic.quizzes.new(quiz_params)
      if @quiz.save
        redirect_to school_admin_course_path(@course), notice: "Quiz created."
      else
        redirect_to school_admin_course_path(@course), alert: "Failed to create quiz."
      end
    end

    def update
      @course = scope_query(Course).find(params[:course_id])
      @chapter = @course.chapters.find(params[:chapter_id])
      @topic = @chapter.topics.find(params[:topic_id])
      @quiz = @topic.quizzes.find(params[:id])
      if @quiz.update(quiz_params)
        redirect_to school_admin_course_path(@course), notice: "Quiz updated."
      else
        redirect_to school_admin_course_path(@course), alert: "Update failed."
      end
    end

    def destroy
      @course = scope_query(Course).find(params[:course_id])
      @chapter = @course.chapters.find(params[:chapter_id])
      @topic = @chapter.topics.find(params[:topic_id])
      @quiz = @topic.quizzes.find(params[:id])
      @quiz.destroy
      redirect_to school_admin_course_path(@course), notice: "Quiz deleted."
    end

    private

    def quiz_params
      params.require(:quiz).permit(:title, :description, :time_limit_minutes, :total_marks, :status)
    end
  end
end
