module SchoolAdmin
  class VehiclesController < BaseController
    include SchoolScope

    def index
      @vehicles = scope_query(Vehicle).order(:name)
    end

    def new
      @vehicle = Vehicle.new
    end

    def create
      @vehicle = scope_query(Vehicle).new(vehicle_params)
      if @vehicle.save
        redirect_to school_admin_vehicles_path, notice: "Vehicle added."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @vehicle = scope_query(Vehicle).find(params[:id])
    end

    def update
      @vehicle = scope_query(Vehicle).find(params[:id])
      if @vehicle.update(vehicle_params)
        redirect_to school_admin_vehicles_path, notice: "Vehicle updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @vehicle = scope_query(Vehicle).find(params[:id])
      @vehicle.destroy
      redirect_to school_admin_vehicles_path, notice: "Vehicle deleted."
    end

    private

    def vehicle_params
      params.require(:vehicle).permit(:name, :registration_number, :vehicle_type, :capacity, :status)
    end
  end
end
