class LessonPlan < ApplicationRecord
  belongs_to :school
  belongs_to :teacher
  belongs_to :classroom
  belongs_to :subject

  enum :status, { draft: "draft", scheduled: "scheduled", completed: "completed", cancelled: "cancelled" }

  validates :chapter, presence: true
  validates :topic, presence: true
  validates :planned_date, presence: true
end
