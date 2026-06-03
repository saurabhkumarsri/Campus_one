class CreateClassroomSubjects < ActiveRecord::Migration[8.1]
  def change
    create_table :classroom_subjects do |t|
      t.bigint :classroom_id, null: false
      t.bigint :subject_id, null: false
      t.bigint :teacher_id

      t.timestamps
    end
    add_index :classroom_subjects, [:classroom_id, :subject_id], unique: true
    add_index :classroom_subjects, :teacher_id
  end
end
