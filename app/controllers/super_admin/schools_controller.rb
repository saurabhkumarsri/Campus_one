module SuperAdmin
  class SchoolsController < BaseController
    def index
      @schools = School.order(created_at: :desc)
    end

    def show
      @school = School.find(params[:id])
    end

    def new
      @school = School.new
    end

    def create
      @school = School.new(school_params)
      auto_set_subscription_expiry!(@school)
      if @school.save
        redirect_to super_admin_schools_path, notice: "School created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @school = School.find(params[:id])
    end

    def update
      @school = School.find(params[:id])
      if @school.update(school_params)
        auto_set_subscription_expiry!(@school)
        redirect_to super_admin_schools_path, notice: "School updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @school = School.find(params[:id])
      @school.destroy
      redirect_to super_admin_schools_path, notice: "School deleted successfully."
    end

    private

    def school_params
      params.require(:school).permit(:name, :email, :phone, :address, :subscription_plan_id, :status)
    end

    def auto_set_subscription_expiry!(school)
      if school.subscription_plan_id.present?
        plan = SubscriptionPlan.find_by(id: school.subscription_plan_id)
        if plan
          school.update_column(:subscription_expiry, plan.duration_months.months.from_now.to_date)
        end
      end
    end
  end
end
