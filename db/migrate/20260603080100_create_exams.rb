class CreateExams < ActiveRecord::Migration[8.1]
  def change
    create_table :exams do |t|
      t.references :school, null: false
      t.references :classroom, null: false
      t.references :section, null: true
      t.references :subject, null: false
      t.string :title, null: false
      t.string :exam_type, null: false, default: "mid_term"
      t.date :exam_date, null: false
      t.time :start_time
      t.time :end_time
      t.integer :max_marks, null: false, default: 100
      t.integer :pass_marks, null: false, default: 35
      t.string :status, null: false, default: "upcoming"
      t.text :instructions
      t.timestamps
    end
  end
end
