class AddPaymentForeignKeys < ActiveRecord::Migration[8.1]
  def change
    add_foreign_key :payments, :schools
    add_foreign_key :payments, :subscription_plans
  end
end
