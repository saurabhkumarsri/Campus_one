class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :role, null: false, default: "school_admin"
      t.bigint :school_id
      t.string :name, null: false
      t.string :status, null: false, default: "active"

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :role
    add_index :users, :school_id
  end
end
