class Quiz < ApplicationRecord
  belongs_to :topic
  has_many :quiz_questions, dependent: :destroy
  has_many :quiz_attempts, dependent: :destroy

  enum :status, { active: "active", inactive: "inactive" }

  validates :title, :total_marks, presence: true
  validates :total_marks, numericality: { greater_than: 0 }

  def total_questions
    quiz_questions.count
  end
end
