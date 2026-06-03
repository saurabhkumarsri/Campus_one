class Payment < ApplicationRecord
  belongs_to :school
  belongs_to :subscription_plan

  enum :status, { pending: "pending", paid: "paid", failed: "failed", refunded: "refunded" }

  validates :amount, numericality: { greater_than: 0 }

  before_create :generate_razorpay_order_id, if: -> { razorpay_order_id.blank? }

  def generate_razorpay_order_id
    self.razorpay_order_id = "order_#{SecureRandom.hex(12)}"
  end

  def verify_signature!(payment_id, signature)
    secret = Rails.application.credentials.dig(:razorpay, :secret_key) || ENV["RAZORPAY_SECRET_KEY"]

    if secret.present?
      expected = OpenSSL::HMAC.hexdigest("SHA256", secret, "#{razorpay_order_id}|#{payment_id}")
      if ActiveSupport::SecurityUtils.secure_compare(expected, signature)
        update!(
          razorpay_payment_id: payment_id,
          razorpay_signature: signature,
          status: "paid"
        )
        return true
      end
      update!(status: "failed")
      false
    else
      # Demo/test mode — no secret configured, accept any payment
      update!(
        razorpay_payment_id: payment_id,
        razorpay_signature: signature,
        status: "paid"
      )
      true
    end
  end
end
