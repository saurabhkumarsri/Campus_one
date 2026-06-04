class Teacher < ApplicationRecord
  belongs_to :school
  has_many :classroom_subjects, dependent: :nullify
  has_many :teacher_attendances, dependent: :destroy
  has_many :homeworks, dependent: :nullify
  has_many :courses, dependent: :nullify
  has_many :live_classes, dependent: :nullify
  has_many :leave_applications, dependent: :nullify
  has_one :user, dependent: :nullify

  enum :status, { active: "active", inactive: "inactive" }

  validates :name, presence: true
  validates :email, uniqueness: { case_sensitive: false, scope: :school_id }, allow_blank: true

  def monthly_attendance_summary(month, year)
    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month
    records = teacher_attendances.where(date: start_date..end_date)
    {
      present: records.where(status: "present").count,
      absent: records.where(status: "absent").count,
      leave: records.where(status: "leave").count,
      total: records.count
    }
  end
end
