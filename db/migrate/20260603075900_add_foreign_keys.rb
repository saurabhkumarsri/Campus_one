class AddForeignKeys < ActiveRecord::Migration[8.1]
  def change
    add_foreign_key :users, :schools
    add_foreign_key :schools, :subscription_plans
    add_foreign_key :classrooms, :schools
    add_foreign_key :sections, :schools
    add_foreign_key :sections, :classrooms
    add_foreign_key :subjects, :schools
    add_foreign_key :classroom_subjects, :classrooms
    add_foreign_key :classroom_subjects, :subjects
    add_foreign_key :classroom_subjects, :teachers
    add_foreign_key :teachers, :schools
    add_foreign_key :students, :schools
    add_foreign_key :students, :classrooms
    add_foreign_key :students, :sections
    add_foreign_key :student_attendances, :students
    add_foreign_key :student_attendances, :classrooms
    add_foreign_key :teacher_attendances, :teachers
    add_foreign_key :fee_structures, :schools
    add_foreign_key :fee_structures, :classrooms
    add_foreign_key :fee_collections, :students
    add_foreign_key :fee_collections, :fee_structures
  end
end
