module SchoolAdmin
  class DriversController < BaseController
    include SchoolScope

    def index
      @drivers = scope_query(Driver).order(:name)
    end

    def new
      @driver = Driver.new
    end

    def create
      @driver = scope_query(Driver).new(driver_params)
      if @driver.save
        redirect_to school_admin_drivers_path, notice: "Driver added."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @driver = scope_query(Driver).find(params[:id])
    end

    def update
      @driver = scope_query(Driver).find(params[:id])
      if @driver.update(driver_params)
        redirect_to school_admin_drivers_path, notice: "Driver updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @driver = scope_query(Driver).find(params[:id])
      @driver.destroy
      redirect_to school_admin_drivers_path, notice: "Driver deleted."
    end

    private

    def driver_params
      params.require(:driver).permit(:name, :phone, :license_number, :address, :status)
    end
  end
end
