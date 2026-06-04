class BookIssue < ApplicationRecord
  belongs_to :school
  belongs_to :library_book
  belongs_to :student, optional: true
  belongs_to :teacher, optional: true

  enum :status, { issued: "issued", returned: "returned", overdue: "overdue" }

  validates :issue_date, :due_date, presence: true

  before_save :calculate_fine, if: -> { return_date_changed? }

  scope :active, -> { where(status: "issued") }
  scope :overdue, -> { where("due_date < ? AND status = ?", Date.today, "issued") }
  scope :for_school, ->(school_id) { where(school_id: school_id) }

  def borrower_name
    student.present? ? student.name : teacher&.name
  end

  def return!
    update!(
      status: "returned",
      return_date: Date.today,
      fine_amount: calculate_fine_amount
    )
    library_book.update!(available_copies: library_book.available_copies + 1)
  end

  def mark_overdue!
    update!(status: "overdue") if due_date < Date.today && status == "issued"
  end

  private

  def calculate_fine
    self.fine_amount = calculate_fine_amount
  end

  def calculate_fine_amount
    return 0 if return_date.blank? || due_date.blank? || return_date <= due_date
    days_overdue = (return_date - due_date).to_i
    days_overdue * 5.0
  end
end
