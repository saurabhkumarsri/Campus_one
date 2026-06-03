class Classroom < ApplicationRecord
  belongs_to :school
  has_many :sections, dependent: :destroy
  has_many :students, dependent: :nullify
  has_many :classroom_subjects, dependent: :destroy
  has_many :subjects, through: :classroom_subjects
  has_many :fee_structures, dependent: :nullify
  has_many :student_attendances, dependent: :destroy

  enum :status, { active: "active", inactive: "inactive" }

  validates :name, presence: true

  def display_name
    name
  end
end
