class CreateHostelRooms < ActiveRecord::Migration[8.1]
  def change
    create_table :hostel_rooms do |t|
      t.references :school, null: false
      t.string :room_number, null: false
      t.string :floor
      t.string :room_type, null: false, default: "standard"
      t.integer :capacity, null: false, default: 2
      t.string :status, null: false, default: "available"
      t.timestamps
    end
  end
end
