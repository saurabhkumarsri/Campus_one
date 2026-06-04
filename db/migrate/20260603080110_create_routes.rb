class CreateRoutes < ActiveRecord::Migration[8.1]
  def change
    create_table :routes do |t|
      t.references :school, null: false
      t.string :name, null: false
      t.references :vehicle, null: false
      t.references :driver, null: false
      t.string :start_location
      t.string :end_location
      t.string :status, null: false, default: "active"
      t.timestamps
    end
  end
end
