class CreateStudentAttendances < ActiveRecord::Migration[8.1]
  def change
    create_table :student_attendances do |t|
      t.bigint :student_id, null: false
      t.bigint :classroom_id, null: false
      t.date :date, null: false
      t.string :status, null: false, default: "present"
      t.string :remarks

      t.timestamps
    end
    add_index :student_attendances, [:student_id, :date], unique: true
    add_index :student_attendances, [:classroom_id, :date]
  end
end
