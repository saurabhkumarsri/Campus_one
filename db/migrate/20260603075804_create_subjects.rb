class CreateSubjects < ActiveRecord::Migration[8.1]
  def change
    create_table :subjects do |t|
      t.bigint :school_id, null: false
      t.string :name, null: false
      t.string :code
      t.string :status, null: false, default: "active"

      t.timestamps
    end
    add_index :subjects, :school_id
  end
end
