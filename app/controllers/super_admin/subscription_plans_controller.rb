module SuperAdmin
  class SubscriptionPlansController < BaseController
    def index
      @plans = SubscriptionPlan.order(created_at: :desc)
    end

    def new
      @plan = SubscriptionPlan.new
    end

    def create
      @plan = SubscriptionPlan.new(plan_params)
      if @plan.save
        redirect_to super_admin_subscription_plans_path, notice: "Plan created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @plan = SubscriptionPlan.find(params[:id])
    end

    def update
      @plan = SubscriptionPlan.find(params[:id])
      if @plan.update(plan_params)
        redirect_to super_admin_subscription_plans_path, notice: "Plan updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @plan = SubscriptionPlan.find(params[:id])
      @plan.destroy
      redirect_to super_admin_subscription_plans_path, notice: "Plan deleted successfully."
    end

    private

    def plan_params
      params.require(:subscription_plan).permit(:name, :price, :duration_months, :features, :status)
    end
  end
end
