class CreateHomeworkSubmissions < ActiveRecord::Migration[8.1]
  def change
    create_table :homework_submissions do |t|
      t.references :homework, null: false
      t.references :student, null: false
      t.text :submission_text
      t.string :status, null: false, default: "pending"
      t.decimal :grade, precision: 5, scale: 2
      t.text :teacher_remarks
      t.datetime :submitted_at
      t.datetime :reviewed_at
      t.timestamps
    end
  end
end
