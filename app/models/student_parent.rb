class StudentParent < ApplicationRecord
  belongs_to :user
  belongs_to :student

  validates :user_id, uniqueness: { scope: :student_id }

  enum :relationship, { father: "father", mother: "mother", guardian: "guardian" }
end
