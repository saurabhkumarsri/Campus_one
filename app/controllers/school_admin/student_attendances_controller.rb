module SchoolAdmin
  class StudentAttendancesController < BaseController
    def index
      @classrooms = scope_query(Classroom).active
      @classroom = @classrooms.find_by(id: params[:classroom_id]) || @classrooms.first
      @date = parse_date(params[:date]) || Date.today

      if @classroom
        @students = scope_query(Student).where(classroom_id: @classroom.id).order(:name)
        @existing = StudentAttendance.where(student_id: @students.select(:id), date: @date).index_by(&:student_id)
      end
    end

    def new
      redirect_to school_admin_student_attendances_path(classroom_id: params[:classroom_id], date: params[:date])
    end

    def create
      classroom = scope_query(Classroom).find(params[:classroom_id])
      date = parse_date(params[:date]) || Date.today

      if params[:attendances].present?
        params[:attendances].each do |student_id, attrs|
          attendance = StudentAttendance.find_or_initialize_by(student_id: student_id, date: date)
          attendance.assign_attributes(
            classroom_id: classroom.id,
            status: attrs[:status],
            remarks: attrs[:remarks]
          )
          attendance.save
        end
      end

      redirect_to school_admin_student_attendances_path(classroom_id: classroom.id, date: date), notice: "Attendance saved successfully."
    end

    def monthly_report
      @classrooms = scope_query(Classroom).active
      @classroom = @classrooms.find_by(id: params[:classroom_id]) || @classrooms.first
      @month = (params[:month] || Date.today.month).to_i
      @year = (params[:year] || Date.today.year).to_i

      if @classroom
        start_date = Date.new(@year, @month, 1)
        end_date = start_date.end_of_month
        @students = scope_query(Student).where(classroom_id: @classroom.id).order(:name)
        @attendances = StudentAttendance.where(student_id: @students.select(:id), date: start_date..end_date)
                                        .group(:student_id, :status)
                                        .count
      end
    end

    private

    def parse_date(value)
      Date.parse(value.to_s) if value.present?
    rescue Date::Error
      nil
    end
  end
end
