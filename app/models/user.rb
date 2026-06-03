class User < ApplicationRecord
  has_secure_password

  belongs_to :school, optional: true

  enum :role, { super_admin: "super_admin", school_admin: "school_admin" }
  enum :status, { active: "active", inactive: "inactive" }

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
  validates :role, presence: true
  validates :password, length: { minimum: 6 }, if: -> { password.present? }

  def super_admin?
    role == "super_admin"
  end

  def school_admin?
    role == "school_admin"
  end

  def active?
    status == "active"
  end
end
