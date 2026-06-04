class Chapter < ApplicationRecord
  belongs_to :course
  has_many :topics, dependent: :destroy

  enum :status, { active: "active", inactive: "inactive" }

  validates :title, :order_position, presence: true

  scope :ordered, -> { order(:order_position) }
end
