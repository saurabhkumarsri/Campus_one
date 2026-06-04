class Student < ApplicationRecord
  belongs_to :school
  belongs_to :classroom, optional: true
  belongs_to :section, optional: true
  has_many :student_attendances, dependent: :destroy
  has_many :fee_collections, dependent: :destroy
  has_many :exam_results, dependent: :destroy
  has_many :homework_submissions, dependent: :destroy
  has_many :quiz_attempts, dependent: :destroy
  has_many :course_enrollments, dependent: :destroy
  has_many :enrolled_courses, through: :course_enrollments, source: :course
  has_many :book_issues, dependent: :nullify
  has_many :live_class_attendances, dependent: :destroy
  has_one :hostel_bed, dependent: :nullify
  has_one :user, dependent: :nullify

  enum :status, { active: "active", inactive: "inactive" }
  enum :gender, { male: "male", female: "female", other: "other" }

  validates :name, presence: true
  validates :roll_no, uniqueness: { scope: :school_id }, allow_blank: true

  def monthly_attendance_summary(month, year)
    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month
    records = student_attendances.where(date: start_date..end_date)
    {
      present: records.where(status: "present").count,
      absent: records.where(status: "absent").count,
      leave: records.where(status: "leave").count,
      total: records.count
    }
  end

  def total_due_fees
    fee_collections.where(status: ["unpaid", "partial"]).sum(:amount)
  end
end
