module SchoolAdmin
  class DashboardController < BaseController
    def index
      @total_teachers = scope_query(Teacher).count
      @total_students = scope_query(Student).count
      @total_classrooms = scope_query(Classroom).count
      @today_student_attendance = StudentAttendance.joins(:student)
                                                   .where(students: { school_id: current_user.school_id }, date: Date.today)
                                                   .group(:status)
                                                   .count
      @today_teacher_attendance = TeacherAttendance.joins(:teacher)
                                                   .where(teachers: { school_id: current_user.school_id }, date: Date.today)
                                                   .group(:status)
                                                   .count
      @due_fees_total = FeeCollection.joins(:student)
                                       .where(students: { school_id: current_user.school_id }, status: ["unpaid", "partial"])
                                       .sum(:amount)
    end
  end
end
