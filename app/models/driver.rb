class Driver < ApplicationRecord
  belongs_to :school
  has_many :routes, dependent: :nullify

  enum :status, { active: "active", on_leave: "on_leave", inactive: "inactive" }

  validates :name, :phone, :license_number, presence: true

  scope :for_school, ->(school_id) { where(school_id: school_id) }
end
