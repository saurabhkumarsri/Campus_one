class GradeSystem < ApplicationRecord
  belongs_to :school

  enum :status, { active: "active", inactive: "inactive" }

  validates :min_marks, :max_marks, :grade, presence: true
  validates :min_marks, numericality: { greater_than_or_equal_to: 0 }
  validates :max_marks, numericality: { greater_than: 0 }
  validates :grade_point, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  scope :for_school, ->(school_id) { where(school_id: school_id) }

  def self.grade_for(marks, school_id)
    where(school_id: school_id)
      .where("min_marks <= ? AND max_marks >= ?", marks, marks)
      .first
  end
end
