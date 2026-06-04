class CreateChapters < ActiveRecord::Migration[8.1]
  def change
    create_table :chapters do |t|
      t.references :course, null: false
      t.string :title, null: false
      t.text :description
      t.integer :order_position, null: false, default: 1
      t.string :status, null: false, default: "active"
      t.timestamps
    end
  end
end
