class CreateTeachers < ActiveRecord::Migration[8.1]
  def change
    create_table :teachers do |t|
      t.bigint :school_id, null: false
      t.string :name, null: false
      t.string :email
      t.string :mobile
      t.string :qualification
      t.text :address
      t.decimal :salary, precision: 10, scale: 2, default: 0
      t.date :joining_date
      t.string :photo
      t.string :status, null: false, default: "active"

      t.timestamps
    end
    add_index :teachers, :email, unique: true
    add_index :teachers, :school_id
  end
end
