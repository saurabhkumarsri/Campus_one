module SchoolAdmin
  class ClassroomsController < BaseController
    def index
      @classrooms = scope_query(Classroom).order(:name)
    end

    def new
      @classroom = Classroom.new
    end

    def create
      @classroom = scope_query(Classroom).new(classroom_params)
      if @classroom.save
        redirect_to school_admin_classrooms_path, notice: "Class created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @classroom = scope_query(Classroom).find(params[:id])
    end

    def update
      @classroom = scope_query(Classroom).find(params[:id])
      if @classroom.update(classroom_params)
        redirect_to school_admin_classrooms_path, notice: "Class updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @classroom = scope_query(Classroom).find(params[:id])
      @classroom.destroy
      redirect_to school_admin_classrooms_path, notice: "Class deleted successfully."
    end

    private

    def classroom_params
      params.require(:classroom).permit(:name, :status).merge(school_id: current_user.school_id)
    end
  end
end
