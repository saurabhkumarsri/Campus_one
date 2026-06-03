class CreateSchools < ActiveRecord::Migration[8.1]
  def change
    create_table :schools do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone
      t.text :address
      t.date :subscription_expiry
      t.bigint :subscription_plan_id
      t.string :status, null: false, default: "active"

      t.timestamps
    end
    add_index :schools, :email, unique: true
    add_index :schools, :subscription_plan_id
  end
end
