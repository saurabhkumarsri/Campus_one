class CreateCourseEnrollments < ActiveRecord::Migration[8.1]
  def change
    create_table :course_enrollments do |t|
      t.references :course, null: false
      t.references :student, null: false
      t.integer :progress_percentage, null: false, default: 0
      t.datetime :completed_at
      t.string :status, null: false, default: "active"
      t.timestamps
    end
  end
end
