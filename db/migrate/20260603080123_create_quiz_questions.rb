class CreateQuizQuestions < ActiveRecord::Migration[8.1]
  def change
    create_table :quiz_questions do |t|
      t.references :quiz, null: false
      t.text :question_text, null: false
      t.string :question_type, null: false, default: "mcq"
      t.jsonb :options, null: false, default: []
      t.string :correct_answer, null: false
      t.integer :marks, null: false, default: 1
      t.timestamps
    end
  end
end
