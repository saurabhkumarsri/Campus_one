class TeacherAttendance < ApplicationRecord
  belongs_to :teacher

  enum :status, { present: "present", absent: "absent", leave: "leave" }

  validates :teacher_id, uniqueness: { scope: :date }
  validates :date, presence: true
end
