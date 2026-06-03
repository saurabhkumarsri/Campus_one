module SuperAdmin
  class DashboardController < BaseController
    def index
      @total_schools = School.count
      @active_schools = School.active_schools.count
      @expiring_schools = School.expiring_soon.count
      @total_school_admins = User.school_admin.count
      @recent_schools = School.order(created_at: :desc).limit(5)
    end
  end
end
