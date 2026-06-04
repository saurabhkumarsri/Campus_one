class CreateQuizAttempts < ActiveRecord::Migration[8.1]
  def change
    create_table :quiz_attempts do |t|
      t.references :quiz, null: false
      t.references :student, null: false
      t.jsonb :answers, null: false, default: {}
      t.integer :score, default: 0
      t.datetime :started_at
      t.datetime :completed_at
      t.string :status, null: false, default: "in_progress"
      t.timestamps
    end
  end
end
