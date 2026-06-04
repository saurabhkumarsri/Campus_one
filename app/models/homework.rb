class Homework < ApplicationRecord
  belongs_to :school
  belongs_to :teacher
  belongs_to :classroom
  belongs_to :section, optional: true
  belongs_to :subject
  has_many :homework_submissions, dependent: :destroy
  has_many_attached :attachments

  enum :status, { active: "active", closed: "closed", draft: "draft" }

  validates :title, :due_date, presence: true

  scope :for_school, ->(school_id) { where(school_id: school_id) }
  scope :for_classroom, ->(id) { where(classroom_id: id) }
  scope :for_section, ->(id) { where(section_id: id) }
  scope :overdue, -> { where("due_date < ?", Date.today).where(status: "active") }
  scope :due_today, -> { where(due_date: Date.today) }

  def submission_stats
    total_students = section.present? ? section.students.count : classroom.students.count
    submitted = homework_submissions.where.not(submitted_at: nil).count
    pending = total_students - submitted
    { total: total_students, submitted: submitted, pending: pending }
  end
end
