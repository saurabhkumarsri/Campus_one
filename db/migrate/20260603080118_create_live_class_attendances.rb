class CreateLiveClassAttendances < ActiveRecord::Migration[8.1]
  def change
    create_table :live_class_attendances do |t|
      t.references :live_class, null: false
      t.references :student, null: false
      t.datetime :joined_at
      t.datetime :left_at
      t.string :status, null: false, default: "absent"
      t.timestamps
    end
  end
end
