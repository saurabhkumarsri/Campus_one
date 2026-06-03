class School < ApplicationRecord
  belongs_to :subscription_plan, optional: true
  has_many :users, dependent: :nullify
  has_many :classrooms, dependent: :destroy
  has_many :sections, dependent: :destroy
  has_many :subjects, dependent: :destroy
  has_many :teachers, dependent: :destroy
  has_many :students, dependent: :destroy
  has_many :fee_structures, dependent: :destroy
  has_many :payments, dependent: :destroy

  enum :status, { active: "active", inactive: "inactive" }

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  scope :active_schools, -> { where(status: "active") }
  scope :expiring_soon, -> { where("subscription_expiry <= ?", 7.days.from_now) }

  def subscription_active?
    subscription_expiry.present? && subscription_expiry >= Date.today
  end

  def subscription_expired?
    subscription_expiry.blank? || subscription_expiry < Date.today
  end

  def subscription_days_remaining
    return 0 if subscription_expiry.blank?
    [(subscription_expiry - Date.today).to_i, 0].max
  end

  def activate_subscription!(plan)
    return unless plan.is_a?(SubscriptionPlan)
    update!(
      subscription_plan: plan,
      subscription_expiry: plan.duration_months.months.from_now.to_date,
      status: "active"
    )
  end
end
