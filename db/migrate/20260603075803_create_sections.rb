class CreateSections < ActiveRecord::Migration[8.1]
  def change
    create_table :sections do |t|
      t.bigint :school_id, null: false
      t.bigint :classroom_id, null: false
      t.string :name, null: false
      t.string :status, null: false, default: "active"

      t.timestamps
    end
    add_index :sections, :school_id
    add_index :sections, :classroom_id
  end
end
