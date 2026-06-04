class CreateAssignmentQuestions < ActiveRecord::Migration[8.1]
  def change
    create_table :assignment_questions do |t|
      t.references :assignment, null: false, foreign_key: true
      t.text :question_text
      t.string :question_type
      t.integer :marks
      t.text :answer_key

      t.timestamps
    end
  end
end
