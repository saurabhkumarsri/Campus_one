module SchoolAdmin
  class TeachersController < BaseController
    def index
      @teachers = scope_query(Teacher).order(:name)
    end

    def show
      @teacher = scope_query(Teacher).find(params[:id])
    end

    def new
      @teacher = Teacher.new
    end

    def create
      @teacher = scope_query(Teacher).new(teacher_params)
      if @teacher.save
        redirect_to school_admin_teachers_path, notice: "Teacher created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @teacher = scope_query(Teacher).find(params[:id])
    end

    def update
      @teacher = scope_query(Teacher).find(params[:id])
      if @teacher.update(teacher_params)
        redirect_to school_admin_teachers_path, notice: "Teacher updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @teacher = scope_query(Teacher).find(params[:id])
      @teacher.destroy
      redirect_to school_admin_teachers_path, notice: "Teacher deleted successfully."
    end

    private

    def teacher_params
      params.require(:teacher).permit(:name, :email, :mobile, :qualification, :address, :salary, :joining_date, :status).merge(school_id: current_user.school_id)
    end
  end
end
