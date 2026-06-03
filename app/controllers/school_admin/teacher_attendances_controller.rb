module SchoolAdmin
  class TeacherAttendancesController < BaseController
    def index
      @date = parse_date(params[:date]) || Date.today
      @teachers = scope_query(Teacher).active.order(:name)
      @existing = TeacherAttendance.where(teacher_id: @teachers.select(:id), date: @date).index_by(&:teacher_id)
    end

    def new
      redirect_to school_admin_teacher_attendances_path(date: params[:date])
    end

    def create
      date = parse_date(params[:date]) || Date.today

      if params[:attendances].present?
        params[:attendances].each do |teacher_id, attrs|
          attendance = TeacherAttendance.find_or_initialize_by(teacher_id: teacher_id, date: date)
          attendance.assign_attributes(
            status: attrs[:status],
            remarks: attrs[:remarks]
          )
          attendance.save
        end
      end

      redirect_to school_admin_teacher_attendances_path(date: date), notice: "Attendance saved successfully."
    end

    def monthly_report
      @month = (params[:month] || Date.today.month).to_i
      @year = (params[:year] || Date.today.year).to_i
      start_date = Date.new(@year, @month, 1)
      end_date = start_date.end_of_month

      @teachers = scope_query(Teacher).active.order(:name)
      @attendances = TeacherAttendance.where(teacher_id: @teachers.select(:id), date: start_date..end_date)
                                      .group(:teacher_id, :status)
                                      .count
    end

    private

    def parse_date(value)
      Date.parse(value.to_s) if value.present?
    rescue Date::Error
      nil
    end
  end
end
