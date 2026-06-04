module SchoolAdmin
  class TeacherDashboardController < BaseController
    def index
      teacher = current_user.teacher
      return redirect_to(root_path, alert: "Teacher profile not found.") unless teacher

      @assigned_classrooms = teacher.classroom_subjects.includes(:classroom, :subject).map { |cs| cs.classroom }.uniq
      @today_classes = Timetable.where(teacher_id: teacher.id, day_of_week: Date.today.strftime("%A").downcase)
                                .includes(:classroom, :subject)
                                .order(:period)
      @total_students = Student.where(classroom_id: @assigned_classrooms.map(&:id)).count
      @pending_homework_reviews = Homework.where(teacher_id: teacher.id)
                                          .joins(:homework_submissions)
                                          .where(homework_submissions: { status: "submitted" })
                                          .distinct
                                          .count
      @upcoming_exams = Exam.where(classroom_id: @assigned_classrooms.map(&:id))
                            .where("exam_date >= ?", Date.today)
                            .order(:exam_date)
                            .limit(5)
      @recent_announcements = Announcement.for_audience("teachers")
                                          .or(Announcement.for_audience("everyone"))
                                          .where(school_id: current_user.school_id)
                                          .published
                                          .recent
                                          .limit(3)
    end
  end
end
