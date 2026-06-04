module SchoolAdmin
  class RouteStopsController < BaseController
    include SchoolScope

    def create
      @route = scope_query(Route).find(params[:route_id])
      @stop = @route.route_stops.new(stop_params)
      if @stop.save
        redirect_to school_admin_route_path(@route), notice: "Stop added."
      else
        redirect_to school_admin_route_path(@route), alert: "Failed to add stop."
      end
    end

    def update
      @route = scope_query(Route).find(params[:route_id])
      @stop = @route.route_stops.find(params[:id])
      if @stop.update(stop_params)
        redirect_to school_admin_route_path(@route), notice: "Stop updated."
      else
        redirect_to school_admin_route_path(@route), alert: "Update failed."
      end
    end

    def destroy
      @route = scope_query(Route).find(params[:route_id])
      @stop = @route.route_stops.find(params[:id])
      @stop.destroy
      redirect_to school_admin_route_path(@route), notice: "Stop removed."
    end

    private

    def stop_params
      params.require(:route_stop).permit(:stop_name, :stop_order, :morning_arrival_time, :evening_arrival_time)
    end
  end
end
