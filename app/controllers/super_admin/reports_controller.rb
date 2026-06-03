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
    end
  end
end
