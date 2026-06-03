class CreateFeeStructures < ActiveRecord::Migration[8.1]
  def change
    create_table :fee_structures do |t|
      t.bigint :school_id, null: false
      t.bigint :classroom_id
      t.string :name, null: false
      t.decimal :amount, precision: 10, scale: 2, default: 0
      t.string :frequency, null: false, default: "monthly"
      t.string :status, null: false, default: "active"

      t.timestamps
    end
    add_index :fee_structures, :school_id
    add_index :fee_structures, :classroom_id
  end
end
