module SchoolAdmin
  class RoutesController < BaseController
    include SchoolScope

    def index
      @routes = scope_query(Route).includes(:vehicle, :driver, :route_stops).order(:name)
    end

    def show
      @route = scope_query(Route).includes(:route_stops).find(params[:id])
      @stop = RouteStop.new
    end

    def new
      @route = Route.new
      load_form_data
    end

    def create
      @route = scope_query(Route).new(route_params)
      if @route.save
        redirect_to school_admin_routes_path, notice: "Route created."
      else
        load_form_data
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @route = scope_query(Route).find(params[:id])
      load_form_data
    end

    def update
      @route = scope_query(Route).find(params[:id])
      if @route.update(route_params)
        redirect_to school_admin_route_path(@route), notice: "Route updated."
      else
        load_form_data
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @route = scope_query(Route).find(params[:id])
      @route.destroy
      redirect_to school_admin_routes_path, notice: "Route deleted."
    end

    private

    def route_params
      params.require(:route).permit(:name, :vehicle_id, :driver_id, :start_location, :end_location, :status)
    end

    def load_form_data
      @vehicles = scope_query(Vehicle).active.order(:name)
      @drivers = scope_query(Driver).active.order(:name)
    end
  end
end
