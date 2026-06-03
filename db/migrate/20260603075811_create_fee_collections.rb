class CreateFeeCollections < ActiveRecord::Migration[8.1]
  def change
    create_table :fee_collections do |t|
      t.bigint :student_id, null: false
      t.bigint :fee_structure_id, null: false
      t.decimal :amount, precision: 10, scale: 2, default: 0
      t.date :paid_date
      t.date :due_date
      t.string :status, null: false, default: "unpaid"
      t.string :payment_mode
      t.string :receipt_no

      t.timestamps
    end
    add_index :fee_collections, :receipt_no, unique: true
    add_index :fee_collections, :student_id
    add_index :fee_collections, :fee_structure_id
  end
end
