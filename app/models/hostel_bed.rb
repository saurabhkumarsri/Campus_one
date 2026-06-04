class HostelBed < ApplicationRecord
  belongs_to :hostel_room
  belongs_to :student, optional: true

  enum :status, { vacant: "vacant", occupied: "occupied", reserved: "reserved" }

  validates :bed_number, presence: true
  validates :bed_number, uniqueness: { scope: :hostel_room_id }

  before_save :sync_status

  scope :vacant, -> { where(status: "vacant") }
  scope :occupied, -> { where(status: "occupied") }

  def allocate!(student)
    update!(student: student, status: "occupied")
    hostel_room.update_status!
  end

  def vacate!
    update!(student: nil, status: "vacant")
    hostel_room.update_status!
  end

  private

  def sync_status
    self.status = student_id.present? ? "occupied" : "vacant"
  end
end
