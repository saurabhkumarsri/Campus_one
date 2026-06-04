class AssignmentQuestion < ApplicationRecord
  belongs_to :assignment

  enum :question_type, { objective: "objective", subjective: "subjective", mcq: "mcq" }

  validates :question_text, presence: true
  validates :marks, numericality: { greater_than: 0 }
end
