class CreateLeaveApplications < ActiveRecord::Migration[8.1]
  def change
    create_table :leave_applications do |t|
      t.references :school, null: false
      t.references :user, null: false
      t.string :applicant_type, null: false, default: "teacher"
      t.string :leave_type, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.text :reason, null: false
      t.string :status, null: false, default: "pending"
      t.references :approved_by, null: true
      t.datetime :approved_on
      t.text :admin_remarks
      t.timestamps
    end
  end
end
