module SuperAdmin
  class ReportsController < BaseController
    def index
      @schools_by_status = School.group(:status).count
      @schools_by_month = School.where("created_at >= ?", 6.months.ago)
                                .group(Arel.sql("DATE_TRUNC('month', created_at)"))
                                .order(Arel.sql("DATE_TRUNC('month', created_at)"))
                                .count
                                .transform_keys { |k| k.strftime("%b %Y") }
      @expiring_subscriptions = School.where("subscription_expiry <= ? AND subscription_expiry >= ?", 30.days.from_now, Date.today).order(:subscription_expiry)

      # Earnings reports
      @total_earnings = Payment.where(status: "paid").sum(:amount)
      @monthly_earnings = Payment.where(status: "paid")
                                 .where(created_at: 12.months.ago..Time.current)
                                 .group(Arel.sql("DATE_TRUNC('month', created_at)"))
                                 .order(Arel.sql("DATE_TRUNC('month', created_at)"))
                                 .sum(:amount)
                                 .transform_keys { |k| k.strftime("%b %Y") }
      @recent_payments = Payment.where(status: "paid").order(created_at: :desc).limit(20).includes(:school, :subscription_plan)
      @earnings_by_plan = Payment.where(status: "paid")
                                 .group(:subscription_plan_id)
                                 .sum(:amount)
                                 .transform_keys { |pid| SubscriptionPlan.find_by(id: pid)&.name || "Unknown" }
    end
  end
end
