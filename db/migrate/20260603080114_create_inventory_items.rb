class CreateInventoryItems < ActiveRecord::Migration[8.1]
  def change
    create_table :inventory_items do |t|
      t.references :school, null: false
      t.string :name, null: false
      t.string :category, null: false
      t.text :description
      t.integer :quantity, null: false, default: 1
      t.string :unit, default: "pieces"
      t.string :condition, default: "good"
      t.date :purchase_date
      t.decimal :purchase_price, precision: 12, scale: 2
      t.string :status, null: false, default: "active"
      t.timestamps
    end
  end
end
