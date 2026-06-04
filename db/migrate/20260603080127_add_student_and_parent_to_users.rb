class AddStudentAndParentToUsers < ActiveRecord::Migration[8.1]
  def change
    add_reference :users, :student, null: true, foreign_key: true
    add_reference :users, :teacher, null: true, foreign_key: true

    create_table :student_parents do |t|
      t.references :user, null: false, foreign_key: true
      t.references :student, null: false, foreign_key: true
      t.string :relationship, default: "father"
      t.timestamps
    end
  end
end
