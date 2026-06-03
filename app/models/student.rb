class Student < ApplicationRecord
  belongs_to :school
  belongs_to :classroom, optional: true
  belongs_to :section, optional: true
  has_many :student_attendances, dependent: :destroy
  has_many :fee_collections, dependent: :destroy

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
