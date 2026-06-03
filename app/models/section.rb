class Section < ApplicationRecord
  belongs_to :school
  belongs_to :classroom
  has_many :students, dependent: :nullify

  enum :status, { active: "active", inactive: "inactive" }

  validates :name, presence: true

  def display_name
    "#{classroom.name} - #{name}"
  end
end
