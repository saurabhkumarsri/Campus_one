class CourseEnrollment < ApplicationRecord
  belongs_to :course
  belongs_to :student

  enum :status, { active: "active", completed: "completed", dropped: "dropped" }

  validates :student_id, uniqueness: { scope: :course_id }
  validates :progress_percentage, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  def update_progress!
    total_topics = course.topics.count
    return if total_topics == 0

    # Progress based on completed quizzes per topic (simplified)
    attempted = QuizAttempt.joins(quiz: { topic: :chapter })
                           .where(student_id: student_id)
                           .where(chapters: { course_id: course_id })
                           .distinct
                           .pluck("topics.id")
                           .count

    pct = ((attempted.to_f / total_topics) * 100).round
    update!(progress_percentage: pct)
    update!(status: "completed", completed_at: Time.current) if pct >= 100
  end
end
