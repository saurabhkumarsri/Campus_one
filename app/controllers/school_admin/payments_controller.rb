module SchoolAdmin
  class PaymentsController < ApplicationController
    before_action :require_school_admin
    before_action :set_payment, only: [:checkout, :verify]
    before_action :ensure_payment_belongs_to_school, only: [:checkout, :verify]

    def index
      @payments = Payment.where(school_id: current_user.school_id).order(created_at: :desc)
      @total_paid = @payments.where(status: "paid").sum(:amount)
      @total_pending = @payments.where(status: "pending").sum(:amount)
    end

    def checkout
      @checkout_data = RazorpayService.checkout_data(@payment)
      @is_live = RazorpayService.live?
    end

    def verify
      payment_id = params[:razorpay_payment_id]
      signature = params[:razorpay_signature]

      if @payment.verify_signature!(payment_id, signature)
        @payment.school.activate_subscription!(@payment.subscription_plan)
        redirect_to school_admin_root_path, notice: "Payment successful! Your #{@payment.subscription_plan.name} subscription is now active till #{@payment.school.subscription_expiry.strftime('%d %b %Y')}."
      else
        redirect_to school_admin_subscriptions_path, alert: "Payment verification failed. Please try again."
      end
    end

    private

    def set_payment
      @payment = Payment.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to school_admin_subscriptions_path, alert: "Payment not found."
    end

    def ensure_payment_belongs_to_school
      unless @payment.school_id == current_user.school_id
        redirect_to school_admin_subscriptions_path, alert: "Unauthorized access."
      end
    end
  end
end
