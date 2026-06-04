class CreateHostelBeds < ActiveRecord::Migration[8.1]
  def change
    create_table :hostel_beds do |t|
      t.references :hostel_room, null: false
      t.string :bed_number, null: false
      t.references :student, null: true
      t.string :status, null: false, default: "vacant"
      t.timestamps
    end
  end
end
