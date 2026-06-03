class CreateSubscriptionPlans < ActiveRecord::Migration[8.1]
  def change
    create_table :subscription_plans do |t|
      t.string :name, null: false
      t.decimal :price, precision: 10, scale: 2, default: 0
      t.integer :duration_months, default: 1
      t.jsonb :features, default: {}
      t.string :status, null: false, default: "active"

      t.timestamps
    end
  end
end
