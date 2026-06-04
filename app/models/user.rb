class User < ApplicationRecord
  has_secure_password

  belongs_to :school, optional: true
  belongs_to :student, optional: true
  belongs_to :teacher, optional: true
  has_many :sent_messages, class_name: "Message", foreign_key: "sender_id", dependent: :nullify
  has_many :received_messages, class_name: "Message", foreign_key: "receiver_id", dependent: :nullify
  has_many :leave_applications, dependent: :destroy
  has_many :ai_generated_contents, dependent: :nullify

  enum :role, { super_admin: "super_admin", school_admin: "school_admin", teacher: "teacher", student: "student" }
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

  def teacher?
    role == "teacher"
  end

  def student?
    role == "student"
  end

  def active?
    status == "active"
  end
end
