class CreateCourses < ActiveRecord::Migration[8.1]
  def change
    create_table :courses do |t|
      t.references :school, null: false
      t.string :title, null: false
      t.text :description
      t.references :classroom, null: false
      t.references :subject, null: false
      t.references :teacher, null: false
      t.string :status, null: false, default: "active"
      t.timestamps
    end
  end
end
