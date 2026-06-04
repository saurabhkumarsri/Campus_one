class Vehicle < ApplicationRecord
  belongs_to :school
  has_many :routes, dependent: :nullify

  enum :vehicle_type, { bus: "bus", van: "van", car: "car", other: "other" }
  enum :status, { active: "active", maintenance: "maintenance", inactive: "inactive" }

  validates :name, :registration_number, :capacity, presence: true
  validates :capacity, numericality: { greater_than: 0 }

  scope :for_school, ->(school_id) { where(school_id: school_id) }
end
