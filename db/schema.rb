# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_06_03_080001) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "classroom_subjects", force: :cascade do |t|
    t.bigint "classroom_id", null: false
    t.datetime "created_at", null: false
    t.bigint "subject_id", null: false
    t.bigint "teacher_id"
    t.datetime "updated_at", null: false
    t.index ["classroom_id", "subject_id"], name: "index_classroom_subjects_on_classroom_id_and_subject_id", unique: true
    t.index ["teacher_id"], name: "index_classroom_subjects_on_teacher_id"
  end

  create_table "classrooms", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "school_id", null: false
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.index ["school_id"], name: "index_classrooms_on_school_id"
  end

  create_table "fee_collections", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.date "due_date"
    t.bigint "fee_structure_id", null: false
    t.date "paid_date"
    t.string "payment_mode"
    t.string "receipt_no"
    t.string "status", default: "unpaid", null: false
    t.bigint "student_id", null: false
    t.datetime "updated_at", null: false
    t.index ["fee_structure_id"], name: "index_fee_collections_on_fee_structure_id"
    t.index ["receipt_no"], name: "index_fee_collections_on_receipt_no", unique: true
    t.index ["student_id"], name: "index_fee_collections_on_student_id"
  end

  create_table "fee_structures", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, default: "0.0"
    t.bigint "classroom_id"
    t.datetime "created_at", null: false
    t.string "frequency", default: "monthly", null: false
    t.string "name", null: false
    t.bigint "school_id", null: false
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.index ["classroom_id"], name: "index_fee_structures_on_classroom_id"
    t.index ["school_id"], name: "index_fee_structures_on_school_id"
  end

  create_table "payments", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.string "payment_method"
    t.string "razorpay_order_id"
    t.string "razorpay_payment_id"
    t.string "razorpay_signature"
    t.bigint "school_id", null: false
    t.string "status", default: "pending", null: false
    t.bigint "subscription_plan_id", null: false
    t.datetime "updated_at", null: false
    t.index ["razorpay_order_id"], name: "index_payments_on_razorpay_order_id", unique: true
    t.index ["razorpay_payment_id"], name: "index_payments_on_razorpay_payment_id", unique: true
    t.index ["school_id"], name: "index_payments_on_school_id"
    t.index ["subscription_plan_id"], name: "index_payments_on_subscription_plan_id"
  end

  create_table "schools", force: :cascade do |t|
    t.text "address"
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.string "phone"
    t.string "status", default: "active", null: false
    t.date "subscription_expiry"
    t.bigint "subscription_plan_id"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_schools_on_email", unique: true
    t.index ["subscription_plan_id"], name: "index_schools_on_subscription_plan_id"
  end

  create_table "sections", force: :cascade do |t|
    t.bigint "classroom_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "school_id", null: false
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.index ["classroom_id"], name: "index_sections_on_classroom_id"
    t.index ["school_id"], name: "index_sections_on_school_id"
  end

  create_table "student_attendances", force: :cascade do |t|
    t.bigint "classroom_id", null: false
    t.datetime "created_at", null: false
    t.date "date", null: false
    t.string "remarks"
    t.string "status", default: "present", null: false
    t.bigint "student_id", null: false
    t.datetime "updated_at", null: false
    t.index ["classroom_id", "date"], name: "index_student_attendances_on_classroom_id_and_date"
    t.index ["student_id", "date"], name: "index_student_attendances_on_student_id_and_date", unique: true
  end

  create_table "students", force: :cascade do |t|
    t.text "address"
    t.date "admission_date"
    t.bigint "classroom_id"
    t.datetime "created_at", null: false
    t.date "date_of_birth"
    t.string "email"
    t.string "father_name"
    t.string "gender"
    t.string "guardian_name"
    t.string "mobile"
    t.string "mother_name"
    t.string "name", null: false
    t.string "photo"
    t.string "roll_no"
    t.bigint "school_id", null: false
    t.bigint "section_id"
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.index ["classroom_id"], name: "index_students_on_classroom_id"
    t.index ["school_id", "roll_no"], name: "index_students_on_school_id_and_roll_no", unique: true
    t.index ["section_id"], name: "index_students_on_section_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "school_id", null: false
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.index ["school_id"], name: "index_subjects_on_school_id"
  end

  create_table "subscription_plans", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "duration_months", default: 1
    t.jsonb "features", default: {}
    t.string "name", null: false
    t.decimal "price", precision: 10, scale: 2, default: "0.0"
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teacher_attendances", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "date", null: false
    t.string "remarks"
    t.string "status", default: "present", null: false
    t.bigint "teacher_id", null: false
    t.datetime "updated_at", null: false
    t.index ["teacher_id", "date"], name: "index_teacher_attendances_on_teacher_id_and_date", unique: true
  end

  create_table "teachers", force: :cascade do |t|
    t.text "address"
    t.datetime "created_at", null: false
    t.string "email"
    t.date "joining_date"
    t.string "mobile"
    t.string "name", null: false
    t.string "photo"
    t.string "qualification"
    t.decimal "salary", precision: 10, scale: 2, default: "0.0"
    t.bigint "school_id", null: false
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_teachers_on_email", unique: true
    t.index ["school_id"], name: "index_teachers_on_school_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.string "role", default: "school_admin", null: false
    t.bigint "school_id"
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["role"], name: "index_users_on_role"
    t.index ["school_id"], name: "index_users_on_school_id"
  end

  add_foreign_key "classroom_subjects", "classrooms"
  add_foreign_key "classroom_subjects", "subjects"
  add_foreign_key "classroom_subjects", "teachers"
  add_foreign_key "classrooms", "schools"
  add_foreign_key "fee_collections", "fee_structures"
  add_foreign_key "fee_collections", "students"
  add_foreign_key "fee_structures", "classrooms"
  add_foreign_key "fee_structures", "schools"
  add_foreign_key "payments", "schools"
  add_foreign_key "payments", "subscription_plans"
  add_foreign_key "schools", "subscription_plans"
  add_foreign_key "sections", "classrooms"
  add_foreign_key "sections", "schools"
  add_foreign_key "student_attendances", "classrooms"
  add_foreign_key "student_attendances", "students"
  add_foreign_key "students", "classrooms"
  add_foreign_key "students", "schools"
  add_foreign_key "students", "sections"
  add_foreign_key "subjects", "schools"
  add_foreign_key "teacher_attendances", "teachers"
  add_foreign_key "teachers", "schools"
  add_foreign_key "users", "schools"
end
