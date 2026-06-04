class AiGeneratedContent < ApplicationRecord
  belongs_to :school
  belongs_to :user

  enum :content_type, {
    report: "report",
    question_paper: "question_paper",
    homework: "homework",
    chatbot_response: "chatbot_response",
    lesson_plan: "lesson_plan"
  }

  validates :content_type, :input_prompt, presence: true

  scope :for_school, ->(school_id) { where(school_id: school_id) }
  scope :by_type, ->(type) { where(content_type: type) }
  scope :recent, -> { order(created_at: :desc) }
end
