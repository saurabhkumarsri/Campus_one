class Message < ApplicationRecord
  belongs_to :school
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  validates :content, presence: true

  scope :for_school, ->(school_id) { where(school_id: school_id) }
  scope :between, ->(u1, u2) {
    where("(sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?)", u1, u2, u2, u1)
  }
  scope :unread, -> { where(read_at: nil) }
  scope :for_user, ->(user_id) { where("sender_id = ? OR receiver_id = ?", user_id, user_id) }

  def mark_read!
    update!(read_at: Time.current) if read_at.nil?
  end

  def unread?
    read_at.nil?
  end
end
