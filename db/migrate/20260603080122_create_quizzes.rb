class CreateQuizzes < ActiveRecord::Migration[8.1]
  def change
    create_table :quizzes do |t|
      t.references :topic, null: false
      t.string :title, null: false
      t.text :description
      t.integer :time_limit_minutes, default: 30
      t.integer :total_marks, null: false, default: 10
      t.string :status, null: false, default: "active"
      t.timestamps
    end
  end
end
