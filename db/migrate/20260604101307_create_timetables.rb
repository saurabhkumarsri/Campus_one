class CreateTimetables < ActiveRecord::Migration[8.1]
  def change
    create_table :timetables do |t|
      t.references :school, null: false, foreign_key: true
      t.references :classroom, null: false, foreign_key: true
      t.references :teacher, null: false, foreign_key: true
      t.references :subject, null: false, foreign_key: true
      t.string :day_of_week
      t.integer :period
      t.time :start_time
      t.time :end_time

      t.timestamps
    end
  end
end
