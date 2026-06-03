class StudentAttendance < ApplicationRecord
  belongs_to :student
  belongs_to :classroom

  enum :status, { present: "present", absent: "absent", leave: "leave" }

  validates :student_id, uniqueness: { scope: :date }
  validates :date, presence: true
end
