class CreateGradeSystems < ActiveRecord::Migration[8.1]
  def change
    create_table :grade_systems do |t|
      t.references :school, null: false
      t.integer :min_marks, null: false
      t.integer :max_marks, null: false
      t.string :grade, null: false
      t.decimal :grade_point, precision: 3, scale: 2
      t.string :status, null: false, default: "active"
      t.timestamps
    end
  end
end
