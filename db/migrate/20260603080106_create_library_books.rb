class CreateLibraryBooks < ActiveRecord::Migration[8.1]
  def change
    create_table :library_books do |t|
      t.references :school, null: false
      t.string :title, null: false
      t.string :author
      t.string :isbn
      t.string :publisher
      t.string :category
      t.integer :total_copies, null: false, default: 1
      t.integer :available_copies, null: false, default: 1
      t.string :shelf_location
      t.string :barcode
      t.string :status, null: false, default: "available"
      t.timestamps
    end
  end
end
