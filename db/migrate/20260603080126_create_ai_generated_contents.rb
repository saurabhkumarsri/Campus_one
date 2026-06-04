class CreateAiGeneratedContents < ActiveRecord::Migration[8.1]
  def change
    create_table :ai_generated_contents do |t|
      t.references :school, null: false
      t.references :user, null: false
      t.string :content_type, null: false
      t.string :topic
      t.string :subject_name
      t.text :input_prompt
      t.text :generated_content
      t.jsonb :metadata, default: {}
      t.timestamps
    end
  end
end
