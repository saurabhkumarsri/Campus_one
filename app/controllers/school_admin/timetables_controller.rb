module SchoolAdmin
  class TimetablesController < BaseController
    def index
      teacher = current_user.teacher
      if teacher
        @timetables = scope_query(Timetable).where(teacher_id: teacher.id).includes(:classroom, :subject).order(:day_of_week, :period)
      else
        @timetables = scope_query(Timetable).includes(:classroom, :subject, :teacher).order(:day_of_week, :period)
      end
    end

    def new
      @timetable = scope_query(Timetable).new
    end

    def create
      @timetable = scope_query(Timetable).new(timetable_params)
      if @timetable.save
        redirect_to school_admin_timetables_path, notice: "Timetable entry created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @timetable = scope_query(Timetable).find(params[:id])
    end

    def update
      @timetable = scope_query(Timetable).find(params[:id])
      if @timetable.update(timetable_params)
        redirect_to school_admin_timetables_path, notice: "Timetable entry updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @timetable = scope_query(Timetable).find(params[:id])
      @timetable.destroy
      redirect_to school_admin_timetables_path, notice: "Timetable entry deleted."
    end

    private

    def timetable_params
      params.require(:timetable).permit(:classroom_id, :teacher_id, :subject_id, :day_of_week, :period, :start_time, :end_time)
    end
  end
end
