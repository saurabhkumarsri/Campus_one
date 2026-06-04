module SchoolAdmin
  class AnalyticsController < BaseController
    include SchoolScope

    def dashboard
      @school = current_user.school
      @total_students = scope_query(Student).active.count
      @total_teachers = scope_query(Teacher).active.count
      @today_attendance = today_attendance_stats
      @monthly_revenue = monthly_revenue_stats
      @exam_performance = exam_performance_stats
      @fee_collection = fee_collection_stats
    end

    def attendance
      @month = (params[:month] || Date.today.month).to_i
      @year = (params[:year] || Date.today.year).to_i
      start_date = Date.new(@year, @month, 1)
      end_date = start_date.end_of_month

      @student_attendance = scope_query(StudentAttendance)
        .where(date: start_date..end_date)
        .group(:status).count

      @teacher_attendance = scope_query(TeacherAttendance)
        .where(date: start_date..end_date)
        .group(:status).count

      @daily_student = scope_query(StudentAttendance)
        .where(date: start_date..end_date)
        .group(:date).count
    end

    def finance
      @monthly_collections = scope_query(FeeCollection)
        .where(created_at: 12.months.ago..Time.current)
        .group(Arel.sql("DATE_TRUNC('month', fee_collections.created_at)"))
        .order(Arel.sql("DATE_TRUNC('month', fee_collections.created_at)"))
        .sum(:amount_paid)
        .transform_keys { |k| k.strftime("%b %Y") }

      @due_fees = scope_query(FeeCollection).where(status: ["unpaid", "partial"]).sum(:remaining_amount)
      @total_collected = scope_query(FeeCollection).sum(:amount_paid)
      @total_transactions = scope_query(FeeCollection).where(status: ["paid", "partial"]).count
      @avg_monthly_collection = @monthly_collections.values.sum / (@monthly_collections.values.size.nonzero? || 1)

      @collection_labels = @monthly_collections.keys
      @collection_values = @monthly_collections.values

      # Fee type breakdown from fee structures
      @fee_type_labels = scope_query(FeeStructure).pluck(:name)
      @fee_type_values = scope_query(FeeCollection).joins(:fee_structure).group("fee_structures.name").sum(:amount_paid).values
    end

    def academic
      @exam_results = scope_query(ExamResult)
        .where(status: "published")
        .group(Arel.sql("DATE_TRUNC('month', exam_results.created_at)"))
        .order(Arel.sql("DATE_TRUNC('month', exam_results.created_at)"))
        .average(:marks_obtained)
        .transform_keys { |k| k.strftime("%b %Y") }

      top_results = scope_query(ExamResult)
        .where(status: "published")
        .select("student_id, AVG(marks_obtained) as avg_marks")
        .group(:student_id)
        .order("avg_marks DESC")
        .limit(10)

      student_ids = top_results.map(&:student_id)
      students = Student.where(id: student_ids).includes(:classroom).index_by(&:id)

      @top_students = top_results.map do |result|
        student = students[result.student_id]
        {
          name: student&.name || "Unknown",
          class: student&.classroom&.name || "-",
          avg_score: result.avg_marks.to_f.round(1),
          highest_subject: "-"
        }
      end
    end

    private

    def today_attendance_stats
      today = Date.today
      student_total = scope_query(StudentAttendance).where(date: today).count
      student_present = scope_query(StudentAttendance).where(date: today, status: "present").count
      teacher_total = scope_query(TeacherAttendance).where(date: today).count
      teacher_present = scope_query(TeacherAttendance).where(date: today, status: "present").count

      {
        student: { total: student_total, present: student_present, percentage: student_total > 0 ? (student_present.to_f / student_total * 100).round(1) : 0 },
        teacher: { total: teacher_total, present: teacher_present, percentage: teacher_total > 0 ? (teacher_present.to_f / teacher_total * 100).round(1) : 0 }
      }
    end

    def monthly_revenue_stats
      scope_query(FeeCollection)
        .where(created_at: 6.months.ago..Time.current)
        .group(Arel.sql("DATE_TRUNC('month', fee_collections.created_at)"))
        .order(Arel.sql("DATE_TRUNC('month', fee_collections.created_at)"))
        .sum(:amount_paid)
        .transform_keys { |k| k.strftime("%b %Y") }
    end

    def exam_performance_stats
      scope_query(ExamResult)
        .where(status: "published")
        .group(:exam_id)
        .average(:marks_obtained)
    end

    def fee_collection_stats
      total = scope_query(FeeCollection).sum(:amount)
      paid = scope_query(FeeCollection).sum(:amount_paid)
      {
        total: total,
        paid: paid,
        due: total - paid,
        percentage: total > 0 ? (paid.to_f / total * 100).round(1) : 0
      }
    end
  end
end
