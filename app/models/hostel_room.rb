class HostelRoom < ApplicationRecord
  belongs_to :school
  has_many :hostel_beds, dependent: :destroy

  enum :room_type, { standard: "standard", deluxe: "deluxe", suite: "suite", dormitory: "dormitory" }
  enum :status, { available: "available", full: "full", maintenance: "maintenance" }

  validates :room_number, :capacity, presence: true
  validates :room_number, uniqueness: { scope: :school_id }

  scope :for_school, ->(school_id) { where(school_id: school_id) }
  scope :with_vacancy, -> { where("status IN (?) OR status = ?", ["available"], "available") }

  def occupied_beds
    hostel_beds.where.not(student_id: nil).count
  end

  def vacant_beds
    capacity - occupied_beds
  end

  def update_status!
    occ = occupied_beds
    new_status = occ >= capacity ? "full" : "available"
    update!(status: new_status) if status != new_status
  end
end
