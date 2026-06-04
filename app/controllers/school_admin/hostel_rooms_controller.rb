module SchoolAdmin
  class HostelRoomsController < BaseController
    include SchoolScope

    def index
      @rooms = scope_query(HostelRoom).includes(:hostel_beds).order(:room_number)
    end

    def show
      @room = scope_query(HostelRoom).includes(:hostel_beds).find(params[:id])
      @bed = HostelBed.new
      @vacant_students = scope_query(Student).active.where.not(id: HostelBed.where.not(student_id: nil).pluck(:student_id))
    end

    def new
      @room = HostelRoom.new
    end

    def create
      @room = scope_query(HostelRoom).new(room_params)
      if @room.save
        redirect_to school_admin_hostel_rooms_path, notice: "Hostel room added."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @room = scope_query(HostelRoom).find(params[:id])
    end

    def update
      @room = scope_query(HostelRoom).find(params[:id])
      if @room.update(room_params)
        redirect_to school_admin_hostel_room_path(@room), notice: "Room updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @room = scope_query(HostelRoom).find(params[:id])
      @room.destroy
      redirect_to school_admin_hostel_rooms_path, notice: "Room deleted."
    end

    private

    def room_params
      params.require(:hostel_room).permit(:room_number, :floor, :room_type, :capacity, :status)
    end
  end
end
