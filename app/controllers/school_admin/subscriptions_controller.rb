module SchoolAdmin
  class SubscriptionsController < ApplicationController
    before_action :require_school_admin

    def index
      @school = current_user.school
      @plans = SubscriptionPlan.where(status: "active").order(:duration_months)
    end

    def create
      @school = current_user.school
      plan = SubscriptionPlan.find(params[:plan_id])

      # Create a pending payment record
      @payment = @school.payments.create!(
        subscription_plan: plan,
        amount: plan.price,
        status: "pending"
      )

      redirect_to checkout_school_admin_payment_path(@payment)
    rescue ActiveRecord::RecordNotFound
      redirect_to school_admin_subscriptions_path, alert: "Invalid plan selected."
    end
  end
end
