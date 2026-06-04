class CreateBookIssues < ActiveRecord::Migration[8.1]
  def change
    create_table :book_issues do |t|
      t.references :school, null: false
      t.references :library_book, null: false
      t.references :student, null: true
      t.references :teacher, null: true
      t.date :issue_date, null: false
      t.date :due_date, null: false
      t.date :return_date
      t.decimal :fine_amount, precision: 10, scale: 2, default: 0
      t.string :status, null: false, default: "issued"
      t.timestamps
    end
  end
end
