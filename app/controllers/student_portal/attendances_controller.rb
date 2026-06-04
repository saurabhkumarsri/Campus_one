module StudentPortal
  class AttendancesController < BaseController
    def index
      @month = (params[:month] || Date.today.month).to_i
      @year = (params[:year] || Date.today.year).to_i
      @summary = @student.monthly_attendance_summary(@month, @year)
      @records = @student.student_attendances.where(date: Date.new(@year, @month, 1)..Date.new(@year, @month, 1).end_of_month).order(:date)
    end
  end
end
