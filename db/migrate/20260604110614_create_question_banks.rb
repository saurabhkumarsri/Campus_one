class CreateQuestionBanks < ActiveRecord::Migration[8.1]
  def change
    create_table :question_banks do |t|
      t.references :school, null: false, foreign_key: true
      t.references :teacher, null: false, foreign_key: true
      t.references :subject, null: false, foreign_key: true
      t.string :difficulty
      t.text :question_text
      t.integer :marks
      t.text :answer_key

      t.timestamps
    end
  end
end
