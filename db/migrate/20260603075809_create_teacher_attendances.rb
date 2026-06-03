class CreateTeacherAttendances < ActiveRecord::Migration[8.1]
  def change
    create_table :teacher_attendances do |t|
      t.bigint :teacher_id, null: false
      t.date :date, null: false
      t.string :status, null: false, default: "present"
      t.string :remarks

      t.timestamps
    end
    add_index :teacher_attendances, [:teacher_id, :date], unique: true
  end
end
