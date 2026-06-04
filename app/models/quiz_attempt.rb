class QuizAttempt < ApplicationRecord
  belongs_to :quiz
  belongs_to :student

  enum :status, { in_progress: "in_progress", completed: "completed", abandoned: "abandoned" }

  validates :answers, presence: true

  before_create :set_started_at

  scope :for_student, ->(student_id) { where(student_id: student_id) }
  scope :completed, -> { where(status: "completed") }

  def complete!
    calculate_score
    update!(status: "completed", completed_at: Time.current)
  end

  private

  def set_started_at
    self.started_at = Time.current
  end

  def calculate_score
    correct = 0
    quiz.quiz_questions.each do |q|
      ans = answers[q.id.to_s] || answers[q.id]
      correct += q.marks if ans.to_s.strip.downcase == q.correct_answer.to_s.strip.downcase
    end
    self.score = correct
  end
end
