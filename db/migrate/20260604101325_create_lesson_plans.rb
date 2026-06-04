class CreateLessonPlans < ActiveRecord::Migration[8.1]
  def change
    create_table :lesson_plans do |t|
      t.references :school, null: false, foreign_key: true
      t.references :teacher, null: false, foreign_key: true
      t.references :classroom, null: false, foreign_key: true
      t.references :subject, null: false, foreign_key: true
      t.string :chapter
      t.string :topic
      t.text :learning_outcome
      t.date :planned_date
      t.string :status

      t.timestamps
    end
  end
end
