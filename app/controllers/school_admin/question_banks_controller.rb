module SchoolAdmin
  class QuestionBanksController < BaseController
    def index
      teacher = current_user.teacher
      if teacher
        @questions = scope_query(QuestionBank).where(teacher_id: teacher.id).includes(:subject).order(:difficulty)
      else
        @questions = scope_query(QuestionBank).includes(:subject, :teacher).order(:difficulty)
      end
    end

    def new
      @question = scope_query(QuestionBank).new
    end

    def create
      @question = scope_query(QuestionBank).new(question_params)
      if @question.save
        redirect_to school_admin_question_banks_path, notice: "Question added to bank."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @question = scope_query(QuestionBank).find(params[:id])
    end

    def update
      @question = scope_query(QuestionBank).find(params[:id])
      if @question.update(question_params)
        redirect_to school_admin_question_banks_path, notice: "Question updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @question = scope_query(QuestionBank).find(params[:id])
      @question.destroy
      redirect_to school_admin_question_banks_path, notice: "Question deleted."
    end

    private

    def question_params
      params.require(:question_bank).permit(:teacher_id, :subject_id, :difficulty, :question_text, :marks, :answer_key)
    end
  end
end
