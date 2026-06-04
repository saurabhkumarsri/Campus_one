class Course < ApplicationRecord
  belongs_to :school
  belongs_to :classroom
  belongs_to :subject
  belongs_to :teacher
  has_many :chapters, dependent: :destroy
  has_many :topics, through: :chapters
  has_many :course_enrollments, dependent: :destroy
  has_many :enrolled_students, through: :course_enrollments, source: :student

  enum :status, { active: "active", inactive: "inactive", draft: "draft" }

  validates :title, presence: true

  scope :for_school, ->(school_id) { where(school_id: school_id) }
  scope :for_classroom, ->(id) { where(classroom_id: id) }
  scope :for_teacher, ->(id) { where(teacher_id: id) }
end
