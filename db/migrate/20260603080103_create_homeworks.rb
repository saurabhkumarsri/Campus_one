class CreateHomeworks < ActiveRecord::Migration[8.1]
  def change
    create_table :homeworks do |t|
      t.references :school, null: false
      t.references :teacher, null: false
      t.references :classroom, null: false
      t.references :section, null: true
      t.references :subject, null: false
      t.string :title, null: false
      t.text :description
      t.date :due_date, null: false
      t.string :status, null: false, default: "active"
      t.timestamps
    end
  end
end
