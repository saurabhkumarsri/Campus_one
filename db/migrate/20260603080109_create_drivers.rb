class CreateDrivers < ActiveRecord::Migration[8.1]
  def change
    create_table :drivers do |t|
      t.references :school, null: false
      t.string :name, null: false
      t.string :phone, null: false
      t.string :license_number, null: false
      t.text :address
      t.string :status, null: false, default: "active"
      t.timestamps
    end
  end
end
