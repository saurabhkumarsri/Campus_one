class RouteStop < ApplicationRecord
  belongs_to :route

  validates :stop_name, :stop_order, presence: true
  validates :stop_order, numericality: { greater_than: 0 }

  scope :ordered, -> { order(:stop_order) }
end
