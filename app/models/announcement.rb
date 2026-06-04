class Announcement < ApplicationRecord
  belongs_to :school
  belongs_to :created_by, class_name: "User"

  enum :audience_type, { everyone: "everyone", teachers: "teachers", students: "students", parents: "parents" }
  enum :priority, { low: "low", normal: "normal", high: "high", urgent: "urgent" }

  validates :title, :content, presence: true

  scope :for_school, ->(school_id) { where(school_id: school_id) }
  scope :published, -> { where("published_at <= ?", Time.current).where("expires_at IS NULL OR expires_at > ?", Time.current) }
  scope :for_audience, ->(type) { where(audience_type: [type, "everyone"]) }
  scope :recent, -> { order(published_at: :desc) }
end
