module StudentPortal
  class DashboardController < BaseController
    def index
      @announcements = scope_query(Announcement).published.for_audience("students").recent.limit(5)
      @homeworks = scope_query(Homework).for_classroom(@student.classroom_id)
        .where("due_date >= ?", Date.today)
        .active
        .order(:due_date)
        .limit(5)
      @upcoming_exams = scope_query(Exam).where(exam_date: Date.today..1.month.from_now).upcoming.order(:exam_date).limit(5)
      @live_classes = scope_query(LiveClass).where(scheduled_at: Time.current..1.day.from_now).scheduled.order(:scheduled_at).limit(5)
      @unread_messages = scope_query(Message).where(receiver_id: current_user.id, read_at: nil).count
    end
  end
end
