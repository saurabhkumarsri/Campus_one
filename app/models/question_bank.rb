class QuestionBank < ApplicationRecord
  belongs_to :school
  belongs_to :teacher
  belongs_to :subject

  enum :difficulty, { easy: "easy", medium: "medium", hard: "hard" }

  validates :question_text, presence: true
  validates :marks, numericality: { greater_than: 0 }
  validates :difficulty, presence: true
end
