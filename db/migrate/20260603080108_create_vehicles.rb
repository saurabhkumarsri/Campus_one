class CreateVehicles < ActiveRecord::Migration[8.1]
  def change
    create_table :vehicles do |t|
      t.references :school, null: false
      t.string :name, null: false
      t.string :registration_number, null: false
      t.string :vehicle_type, null: false, default: "bus"
      t.integer :capacity, null: false, default: 40
      t.string :status, null: false, default: "active"
      t.timestamps
    end
  end
end
