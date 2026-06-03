class CreateStudents < ActiveRecord::Migration[8.1]
  def change
    create_table :students do |t|
      t.bigint :school_id, null: false
      t.bigint :classroom_id
      t.bigint :section_id
      t.string :name, null: false
      t.string :roll_no
      t.string :father_name
      t.string :mother_name
      t.string :guardian_name
      t.string :mobile
      t.string :email
      t.text :address
      t.date :date_of_birth
      t.string :gender
      t.date :admission_date
      t.string :photo
      t.string :status, null: false, default: "active"

      t.timestamps
    end
    add_index :students, [:school_id, :roll_no], unique: true
    add_index :students, :classroom_id
    add_index :students, :section_id
  end
end
