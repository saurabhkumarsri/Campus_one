class SubscriptionPlan < ApplicationRecord
  has_many :schools, dependent: :nullify
  has_many :payments, dependent: :nullify

  enum :status, { active: "active", inactive: "inactive" }

  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :duration_months, numericality: { greater_than: 0 }
end
