class LiveClass < ApplicationRecord
  belongs_to :school
  belongs_to :classroom
  belongs_to :section, optional: true
  belongs_to :subject
  belongs_to :teacher
  has_many :live_class_attendances, dependent: :destroy

  enum :platform, { zoom: "zoom", google_meet: "google_meet", microsoft_teams: "microsoft_teams", other: "other" }
  enum :status, { scheduled: "scheduled", live: "live", completed: "completed", cancelled: "cancelled" }

  validates :title, :scheduled_at, :duration_minutes, presence: true

  scope :for_school, ->(school_id) { where(school_id: school_id) }
  scope :upcoming, -> { where("scheduled_at > ?", Time.current).where(status: "scheduled") }
  scope :today, -> { where("scheduled_at::date = ?", Date.today) }

  def attendance_percentage
    total = section.present? ? section.students.count : classroom.students.count
    return 0 if total == 0
    present = live_class_attendances.where(status: "present").count
    (present.to_f / total * 100).round(1)
  end
end
