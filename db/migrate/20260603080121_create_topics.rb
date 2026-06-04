class CreateTopics < ActiveRecord::Migration[8.1]
  def change
    create_table :topics do |t|
      t.references :chapter, null: false
      t.string :title, null: false
      t.text :content
      t.string :video_url
      t.string :pdf_url
      t.integer :order_position, null: false, default: 1
      t.string :status, null: false, default: "active"
      t.timestamps
    end
  end
end
