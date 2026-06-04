class ExamResult < ApplicationRecord
  belongs_to :exam
  belongs_to :student

  enum :status, { pending: "pending", published: "published", withheld: "withheld" }

  validates :marks_obtained, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  before_save :calculate_grade, if: -> { marks_obtained_changed? }

  scope :for_exam, ->(exam_id) { where(exam_id: exam_id) }
  scope :for_student, ->(student_id) { where(student_id: student_id) }

  private

  def calculate_grade
    return unless marks_obtained.present?

    gs = GradeSystem.grade_for(marks_obtained, exam.school_id)
    if gs
      self.grade = gs.grade
      self.grade_point = gs.grade_point
    end
  end
end
