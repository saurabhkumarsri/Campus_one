class CreateAssignments < ActiveRecord::Migration[8.1]
  def change
    create_table :assignments do |t|
      t.references :school, null: false, foreign_key: true
      t.references :teacher, null: false, foreign_key: true
      t.references :classroom, null: false, foreign_key: true
      t.references :subject, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.date :due_date
      t.integer :max_marks
      t.string :status

      t.timestamps
    end
  end
end
