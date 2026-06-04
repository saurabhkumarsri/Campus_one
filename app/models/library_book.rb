class LibraryBook < ApplicationRecord
  belongs_to :school
  has_many :book_issues, dependent: :destroy

  enum :status, { available: "available", issued: "issued", damaged: "damaged", lost: "lost" }

  validates :title, :total_copies, presence: true
  validates :total_copies, numericality: { greater_than: 0 }

  before_create :set_barcode, if: -> { barcode.blank? }
  before_save :sync_available_copies

  scope :for_school, ->(school_id) { where(school_id: school_id) }
  scope :available, -> { where("available_copies > 0") }
  scope :search, ->(q) { where("title ILIKE ? OR author ILIKE ? OR isbn ILIKE ?", "%#{q}%", "%#{q}%", "%#{q}%") }

  def issue_to!(student: nil, teacher: nil)
    raise "No copies available" if available_copies <= 0

    BookIssue.create!(
      school: school,
      library_book: self,
      student: student,
      teacher: teacher,
      issue_date: Date.today,
      due_date: Date.today + 14.days,
      status: "issued"
    )
  end

  private

  def set_barcode
    self.barcode = "LIB-#{school_id}-#{SecureRandom.hex(4).upcase}"
  end

  def sync_available_copies
    issued_count = book_issues.where(status: "issued").count
    self.available_copies = total_copies - issued_count
  end
end
