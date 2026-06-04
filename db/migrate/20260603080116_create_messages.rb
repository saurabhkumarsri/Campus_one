class CreateMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :messages do |t|
      t.references :school, null: false
      t.references :sender, null: false
      t.references :receiver, null: false
      t.text :content, null: false
      t.datetime :read_at
      t.timestamps
    end
  end
end
