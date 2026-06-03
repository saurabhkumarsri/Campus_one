class Subject < ApplicationRecord
  belongs_to :school
  has_many :classroom_subjects, dependent: :destroy
  has_many :classrooms, through: :classroom_subjects

  enum :status, { active: "active", inactive: "inactive" }

  validates :name, presence: true
end
