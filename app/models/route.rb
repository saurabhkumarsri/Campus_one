class Route < ApplicationRecord
  belongs_to :school
  belongs_to :vehicle
  belongs_to :driver
  has_many :route_stops, dependent: :destroy

  enum :status, { active: "active", inactive: "inactive" }

  validates :name, presence: true

  scope :for_school, ->(school_id) { where(school_id: school_id) }
end
