class InventoryItem < ApplicationRecord
  belongs_to :school

  enum :condition, { excellent: "excellent", good: "good", fair: "fair", poor: "poor" }
  enum :status, { active: "active", disposed: "disposed", lost: "lost" }

  validates :name, :category, :quantity, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }

  scope :for_school, ->(school_id) { where(school_id: school_id) }
  scope :by_category, ->(cat) { where(category: cat) }
  scope :low_stock, -> { where("quantity <= 2") }

  CATEGORIES = %w[Computers Projectors Furniture Lab_Equipment Stationery Sports_Other].freeze
end
