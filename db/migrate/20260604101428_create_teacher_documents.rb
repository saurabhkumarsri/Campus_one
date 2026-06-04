class CreateTeacherDocuments < ActiveRecord::Migration[8.1]
  def change
    create_table :teacher_documents do |t|
      t.references :school, null: false, foreign_key: true
      t.references :teacher, null: false, foreign_key: true
      t.string :doc_type
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
