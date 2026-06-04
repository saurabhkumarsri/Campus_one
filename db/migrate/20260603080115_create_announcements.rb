class CreateAnnouncements < ActiveRecord::Migration[8.1]
  def change
    create_table :announcements do |t|
      t.references :school, null: false
      t.string :title, null: false
      t.text :content, null: false
      t.string :audience_type, null: false, default: "all"
      t.string :priority, null: false, default: "normal"
      t.datetime :published_at
      t.datetime :expires_at
      t.references :created_by, null: false
      t.timestamps
    end
  end
end
