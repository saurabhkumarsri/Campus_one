class RazorpayService
  def self.key_id
    Rails.application.credentials.dig(:razorpay, :key_id) || ENV["RAZORPAY_KEY_ID"]
  end

  def self.secret_key
    Rails.application.credentials.dig(:razorpay, :secret_key) || ENV["RAZORPAY_SECRET_KEY"]
  end

  def self.live?
    key_id.present? && secret_key.present?
  end

  def self.create_order!(payment)
    if live?
      begin
        order = Razorpay::Order.create(
          amount: (payment.amount * 100).to_i,
          currency: "INR",
          receipt: payment.razorpay_order_id,
          notes: {
            school_id: payment.school_id,
            plan_id: payment.subscription_plan_id
          }
        )
        payment.update_column(:razorpay_order_id, order.id)
        order.id
      rescue Razorpay::Error => e
        Rails.logger.error "Razorpay Order Error: #{e.message}"
        payment.razorpay_order_id
      end
    else
      # Test/demo mode — return the mock order ID
      payment.razorpay_order_id
    end
  end

  def self.checkout_data(payment)
    order_id = create_order!(payment)
    {
      key: key_id || "rzp_test_demo_key",
      amount: (payment.amount * 100).to_i,
      currency: "INR",
      name: "Campus One",
      description: "#{payment.subscription_plan.name} Subscription",
      order_id: order_id,
      prefill: {
        name: payment.school.name,
        email: payment.school.email,
        contact: payment.school.phone || ""
      },
      theme: { color: "#2563eb" }
    }
  end
end
