class Exam < ApplicationRecord
  belongs_to :school
  belongs_to :classroom
  belongs_to :section, optional: true
  belongs_to :subject
  has_many :exam_results, dependent: :destroy

  enum :exam_type, { mid_term: "mid_term", final: "final", weekly_test: "weekly_test", unit_test: "unit_test", quiz: "quiz" }
  enum :status, { upcoming: "upcoming", ongoing: "ongoing", completed: "completed", cancelled: "cancelled" }

  validates :title, :exam_date, :max_marks, :pass_marks, presence: true
  validates :max_marks, :pass_marks, numericality: { greater_than: 0 }

  scope :for_school, ->(school_id) { where(school_id: school_id) }
  scope :upcoming, -> { where(status: "upcoming") }
  scope :today, -> { where(exam_date: Date.today) }

  def result_stats
    results = exam_results.where(status: "published")
    return { total: 0, pass: 0, fail: 0, avg: 0, highest: 0 } if results.empty?

    marks = results.pluck(:marks_obtained).compact.map(&:to_f)
    {
      total: results.count,
      pass: results.where("marks_obtained >= ?", pass_marks).count,
      fail: results.where("marks_obtained < ?", pass_marks).count,
      avg: (marks.sum / marks.size).round(2),
      highest: marks.max
    }
  end

  def class_ranking
    exam_results.where(status: "published").order(marks_obtained: :desc)
  end
end
