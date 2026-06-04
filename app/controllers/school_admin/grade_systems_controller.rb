module SchoolAdmin
  class GradeSystemsController < BaseController
    include SchoolScope

    def index
      @grade_systems = scope_query(GradeSystem).order(min_marks: :desc)
    end

    def new
      @grade_system = GradeSystem.new
    end

    def create
      @grade_system = scope_query(GradeSystem).new(grade_params)
      if @grade_system.save
        redirect_to school_admin_grade_systems_path, notice: "Grade system entry added."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @grade_system = scope_query(GradeSystem).find(params[:id])
    end

    def update
      @grade_system = scope_query(GradeSystem).find(params[:id])
      if @grade_system.update(grade_params)
        redirect_to school_admin_grade_systems_path, notice: "Grade system entry updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @grade_system = scope_query(GradeSystem).find(params[:id])
      @grade_system.destroy
      redirect_to school_admin_grade_systems_path, notice: "Entry deleted."
    end

    private

    def grade_params
      params.require(:grade_system).permit(:min_marks, :max_marks, :grade, :grade_point)
    end
  end
end
