module SchoolAdmin
  class LeaveApplicationsController < BaseController
    include SchoolScope

    def index
      @applications = scope_query(LeaveApplication).includes(:user, :approved_by).order(created_at: :desc)
      @applications = @applications.where(status: params[:status]) if params[:status].present?
      @pending_count = @applications.pending.count
    end

    def show
      @application = scope_query(LeaveApplication).find(params[:id])
    end

    def edit
      @application = scope_query(LeaveApplication).find(params[:id])
    end

    def update
      @application = scope_query(LeaveApplication).find(params[:id])
      action = params[:commit]&.downcase

      if action&.include?("approve")
        @application.approve!(current_user, params[:admin_remarks])
        redirect_to school_admin_leave_applications_path, notice: "Leave approved."
      elsif action&.include?("reject")
        @application.reject!(current_user, params[:admin_remarks])
        redirect_to school_admin_leave_applications_path, notice: "Leave rejected."
      elsif @application.update(leave_params)
        redirect_to school_admin_leave_applications_path, notice: "Application updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def leave_params
      params.require(:leave_application).permit(:status, :admin_remarks)
    end
  end
end
