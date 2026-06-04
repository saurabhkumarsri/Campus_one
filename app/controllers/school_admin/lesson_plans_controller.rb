module SchoolAdmin
  class LessonPlansController < BaseController
    def index
      teacher = current_user.teacher
      if teacher
        @lesson_plans = scope_query(LessonPlan).where(teacher_id: teacher.id).includes(:classroom, :subject).order(:planned_date)
      else
        @lesson_plans = scope_query(LessonPlan).includes(:classroom, :subject, :teacher).order(:planned_date)
      end
    end

    def new
      @lesson_plan = scope_query(LessonPlan).new
    end

    def create
      @lesson_plan = scope_query(LessonPlan).new(lesson_plan_params)
      if @lesson_plan.save
        redirect_to school_admin_lesson_plans_path, notice: "Lesson plan created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @lesson_plan = scope_query(LessonPlan).find(params[:id])
    end

    def update
      @lesson_plan = scope_query(LessonPlan).find(params[:id])
      if @lesson_plan.update(lesson_plan_params)
        redirect_to school_admin_lesson_plans_path, notice: "Lesson plan updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @lesson_plan = scope_query(LessonPlan).find(params[:id])
      @lesson_plan.destroy
      redirect_to school_admin_lesson_plans_path, notice: "Lesson plan deleted."
    end

    private

    def lesson_plan_params
      params.require(:lesson_plan).permit(:classroom_id, :teacher_id, :subject_id, :chapter, :topic, :learning_outcome, :planned_date, :status)
    end
  end
end
