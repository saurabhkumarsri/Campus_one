class LiveClassAttendance < ApplicationRecord
  belongs_to :live_class
  belongs_to :student

  enum :status, { absent: "absent", present: "present", late: "late" }

  validates :live_class_id, uniqueness: { scope: :student_id }

  scope :for_live_class, ->(live_class_id) { where(live_class_id: live_class_id) }
  scope :present, -> { where(status: "present") }
end
