module SchoolAdmin
  class QuizQuestionsController < BaseController
    include SchoolScope

    def create
      @course = scope_query(Course).find(params[:course_id])
      @chapter = @course.chapters.find(params[:chapter_id])
      @topic = @chapter.topics.find(params[:topic_id])
      @quiz = @topic.quizzes.find(params[:quiz_id])
      @question = @quiz.quiz_questions.new(question_params)
      if @question.save
        redirect_to school_admin_course_path(@course), notice: "Question added."
      else
        redirect_to school_admin_course_path(@course), alert: "Failed to add question."
      end
    end

    def update
      @course = scope_query(Course).find(params[:course_id])
      @chapter = @course.chapters.find(params[:chapter_id])
      @topic = @chapter.topics.find(params[:topic_id])
      @quiz = @topic.quizzes.find(params[:quiz_id])
      @question = @quiz.quiz_questions.find(params[:id])
      if @question.update(question_params)
        redirect_to school_admin_course_path(@course), notice: "Question updated."
      else
        redirect_to school_admin_course_path(@course), alert: "Update failed."
      end
    end

    def destroy
      @course = scope_query(Course).find(params[:course_id])
      @chapter = @course.chapters.find(params[:chapter_id])
      @topic = @chapter.topics.find(params[:topic_id])
      @quiz = @topic.quizzes.find(params[:quiz_id])
      @question = @quiz.quiz_questions.find(params[:id])
      @question.destroy
      redirect_to school_admin_course_path(@course), notice: "Question removed."
    end

    private

    def question_params
      params.require(:quiz_question).permit(:question_text, :question_type, :options, :correct_answer, :marks)
    end
  end
end
