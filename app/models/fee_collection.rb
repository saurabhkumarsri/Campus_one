class FeeCollection < ApplicationRecord
  belongs_to :student
  belongs_to :fee_structure

  enum :status, { paid: "paid", unpaid: "unpaid", partial: "partial" }

  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  validates :receipt_no, uniqueness: true, allow_blank: true

  before_create :generate_receipt_number, if: -> { receipt_no.blank? }

  def generate_receipt_number
    self.receipt_no = "RCP-#{Time.current.to_i}-#{student_id}"
  end
end
