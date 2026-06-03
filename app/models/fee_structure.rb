class FeeStructure < ApplicationRecord
  belongs_to :school
  belongs_to :classroom, optional: true
  has_many :fee_collections, dependent: :destroy

  enum :status, { active: "active", inactive: "inactive" }
  enum :frequency, { monthly: "monthly", quarterly: "quarterly", yearly: "yearly", one_time: "one_time" }

  validates :name, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  validates :frequency, presence: true
end
