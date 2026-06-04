module SchoolAdmin
  class HostelBedsController < BaseController
    include SchoolScope

    def create
      @room = scope_query(HostelRoom).find(params[:hostel_room_id])
      @bed = @room.hostel_beds.new(bed_params)
      if @bed.save
        redirect_to school_admin_hostel_room_path(@room), notice: "Bed added."
      else
        redirect_to school_admin_hostel_room_path(@room), alert: "Failed to add bed."
      end
    end

    def update
      @room = scope_query(HostelRoom).find(params[:hostel_room_id])
      @bed = @room.hostel_beds.find(params[:id])
      if params[:student_id].present?
        student = scope_query(Student).find(params[:student_id])
        @bed.allocate!(student)
        redirect_to school_admin_hostel_room_path(@room), notice: "Bed allocated to #{student.name}."
      elsif params[:vacate].present?
        @bed.vacate!
        redirect_to school_admin_hostel_room_path(@room), notice: "Bed vacated."
      elsif @bed.update(bed_params)
        redirect_to school_admin_hostel_room_path(@room), notice: "Bed updated."
      else
        redirect_to school_admin_hostel_room_path(@room), alert: "Update failed."
      end
    end

    def destroy
      @room = scope_query(HostelRoom).find(params[:hostel_room_id])
      @bed = @room.hostel_beds.find(params[:id])
      @bed.destroy
      redirect_to school_admin_hostel_room_path(@room), notice: "Bed removed."
    end

    private

    def bed_params
      params.require(:hostel_bed).permit(:bed_number, :student_id, :status)
    end
  end
end
