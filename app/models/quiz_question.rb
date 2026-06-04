class QuizQuestion < ApplicationRecord
  belongs_to :quiz

  enum :question_type, { mcq: "mcq", true_false: "true_false", short_answer: "short_answer" }

  validates :question_text, :correct_answer, :marks, presence: true
  validates :marks, numericality: { greater_than: 0 }

  def options_array
    options.is_a?(String) ? JSON.parse(options) : options
  rescue
    []
  end
end
