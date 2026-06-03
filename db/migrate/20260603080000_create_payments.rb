class CreatePayments < ActiveRecord::Migration[8.1]
  def change
    create_table :payments do |t|
      t.bigint :school_id, null: false
      t.bigint :subscription_plan_id, null: false
      t.decimal :amount, precision: 10, scale: 2, default: 0
      t.string :razorpay_order_id
      t.string :razorpay_payment_id
      t.string :razorpay_signature
      t.string :status, null: false, default: "pending"
      t.string :payment_method
      t.timestamps
    end
    add_index :payments, :razorpay_order_id, unique: true
    add_index :payments, :razorpay_payment_id, unique: true
    add_index :payments, :school_id
    add_index :payments, :subscription_plan_id
  end
end
