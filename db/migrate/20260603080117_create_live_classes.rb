class CreateLiveClasses < ActiveRecord::Migration[8.1]
  def change
    create_table :live_classes do |t|
      t.references :school, null: false
      t.string :title, null: false
      t.references :classroom, null: false
      t.references :section, null: true
      t.references :subject, null: false
      t.references :teacher, null: false
      t.string :platform, null: false, default: "zoom"
      t.string :meeting_url
      t.string :meeting_id
      t.string :passcode
      t.datetime :scheduled_at, null: false
      t.integer :duration_minutes, default: 60
      t.string :recording_url
      t.string :status, null: false, default: "scheduled"
      t.timestamps
    end
  end
end
