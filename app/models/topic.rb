class Topic < ApplicationRecord
  belongs_to :chapter
  has_many :quizzes, dependent: :destroy

  enum :status, { active: "active", inactive: "inactive" }

  validates :title, :order_position, presence: true

  scope :ordered, -> { order(:order_position) }
end
