class CreateExamResults < ActiveRecord::Migration[8.1]
  def change
    create_table :exam_results do |t|
      t.references :exam, null: false
      t.references :student, null: false
      t.decimal :marks_obtained, precision: 6, scale: 2
      t.string :grade
      t.decimal :grade_point, precision: 3, scale: 2
      t.string :status, null: false, default: "pending"
      t.text :remarks
      t.timestamps
    end
  end
end
