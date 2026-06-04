class LeaveApplication < ApplicationRecord
  belongs_to :school
  belongs_to :user
  belongs_to :approved_by, class_name: "User", optional: true

  enum :applicant_type, { teacher: "teacher", student: "student", staff: "staff" }
  enum :leave_type, { sick: "sick", casual: "casual", emergency: "emergency", maternity: "maternity", other: "other" }
  enum :status, { pending: "pending", approved: "approved", rejected: "rejected" }

  validates :start_date, :end_date, :reason, presence: true
  validate :end_date_after_start_date
  validate :no_past_dates, on: :create

  scope :for_school, ->(school_id) { where(school_id: school_id) }
  scope :pending, -> { where(status: "pending") }
  scope :for_user, ->(user_id) { where(user_id: user_id) }

  def duration_days
    (end_date - start_date).to_i + 1
  end

  def approve!(by_user, remarks = nil)
    update!(
      status: "approved",
      approved_by: by_user,
      approved_on: Time.current,
      admin_remarks: remarks
    )
  end

  def reject!(by_user, remarks = nil)
    update!(
      status: "rejected",
      approved_by: by_user,
      approved_on: Time.current,
      admin_remarks: remarks
    )
  end

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?
    errors.add(:end_date, "must be after or equal to start date") if end_date < start_date
  end

  def no_past_dates
    return if start_date.blank?
    errors.add(:start_date, "cannot be in the past") if start_date < Date.today
  end
end
