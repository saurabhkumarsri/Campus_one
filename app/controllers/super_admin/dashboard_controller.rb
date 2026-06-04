module SuperAdmin
  class DashboardController < BaseController
    def index
      @total_schools = School.count
      @active_schools = School.active_schools.count
      @expiring_schools = School.expiring_soon.count
      @total_school_admins = User.school_admin.count
      @recent_schools = School.order(created_at: :desc).limit(5)

      # Subscription earnings
      @total_subscription_earnings = Payment.where(status: "paid").sum(:amount)
      @this_month_earnings = Payment.where(status: "paid")
                                    .where(created_at: Time.current.beginning_of_month..Time.current.end_of_month)
                                    .sum(:amount)
      @this_year_earnings = Payment.where(status: "paid")
                                 .where(created_at: Time.current.beginning_of_year..Time.current.end_of_year)
                                 .sum(:amount)
      @total_paid_schools = Payment.where(status: "paid").distinct.count(:school_id)
    end
  end
end
