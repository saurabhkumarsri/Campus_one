class HomeworkSubmission < ApplicationRecord
  belongs_to :homework
  belongs_to :student
  has_many_attached :attachments

  enum :status, { pending: "pending", submitted: "submitted", reviewed: "reviewed", late: "late" }

  validates :submission_text, presence: true, if: -> { attachments.empty? }

  before_create :set_submitted_at, if: -> { submitted_at.nil? }

  scope :for_homework, ->(homework_id) { where(homework_id: homework_id) }
  scope :for_student, ->(student_id) { where(student_id: student_id) }

  def mark_as_reviewed!(grade_value, remarks = nil)
    update!(
      grade: grade_value,
      teacher_remarks: remarks,
      status: "reviewed",
      reviewed_at: Time.current
    )
  end

  private

  def set_submitted_at
    self.submitted_at = Time.current
    self.status = homework.due_date < Date.today ? "late" : "submitted"
  end
end
