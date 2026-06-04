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

ActiveRecord::Schema[8.1].define(version: 2026_06_04_110614) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "ai_generated_contents", force: :cascade do |t|
    t.string "content_type", null: false
    t.datetime "created_at", null: false
    t.text "generated_content"
    t.text "input_prompt"
    t.jsonb "metadata", default: {}
    t.bigint "school_id", null: false
    t.string "subject_name"
    t.string "topic"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["school_id"], name: "index_ai_generated_contents_on_school_id"
    t.index ["user_id"], name: "index_ai_generated_contents_on_user_id"
  end

  create_table "announcements", force: :cascade do |t|
    t.string "audience_type", default: "all", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.bigint "created_by_id", null: false
    t.datetime "expires_at"
    t.string "priority", default: "normal", null: false
    t.datetime "published_at"
    t.bigint "school_id", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_announcements_on_created_by_id"
    t.index ["school_id"], name: "index_announcements_on_school_id"
  end

  create_table "assignment_questions", force: :cascade do |t|
    t.text "answer_key"
    t.bigint "assignment_id", null: false
    t.datetime "created_at", null: false
    t.integer "marks"
    t.text "question_text"
    t.string "question_type"
    t.datetime "updated_at", null: false
    t.index ["assignment_id"], name: "index_assignment_questions_on_assignment_id"
  end

  create_table "assignments", force: :cascade do |t|
    t.bigint "classroom_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.date "due_date"
    t.integer "max_marks"
    t.bigint "school_id", null: false
    t.string "status"
    t.bigint "subject_id", null: false
    t.bigint "teacher_id", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["classroom_id"], name: "index_assignments_on_classroom_id"
    t.index ["school_id"], name: "index_assignments_on_school_id"
    t.index ["subject_id"], name: "index_assignments_on_subject_id"
    t.index ["teacher_id"], name: "index_assignments_on_teacher_id"
  end

  create_table "book_issues", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "due_date", null: false
    t.decimal "fine_amount", precision: 10, scale: 2, default: "0.0"
    t.date "issue_date", null: false
    t.bigint "library_book_id", null: false
    t.date "return_date"
    t.bigint "school_id", null: false
    t.string "status", default: "issued", null: false
    t.bigint "student_id"
    t.bigint "teacher_id"
    t.datetime "updated_at", null: false
    t.index ["library_book_id"], name: "index_book_issues_on_library_book_id"
    t.index ["school_id"], name: "index_book_issues_on_school_id"
    t.index ["student_id"], name: "index_book_issues_on_student_id"
    t.index ["teacher_id"], name: "index_book_issues_on_teacher_id"
  end

  create_table "chapters", force: :cascade do |t|
    t.bigint "course_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "order_position", default: 1, null: false
    t.string "status", default: "active", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_chapters_on_course_id"
  end

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

  create_table "course_enrollments", force: :cascade do |t|
    t.datetime "completed_at"
    t.bigint "course_id", null: false
    t.datetime "created_at", null: false
    t.integer "progress_percentage", default: 0, null: false
    t.string "status", default: "active", null: false
    t.bigint "student_id", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_course_enrollments_on_course_id"
    t.index ["student_id"], name: "index_course_enrollments_on_student_id"
  end

  create_table "courses", force: :cascade do |t|
    t.bigint "classroom_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.bigint "school_id", null: false
    t.string "status", default: "active", null: false
    t.bigint "subject_id", null: false
    t.bigint "teacher_id", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["classroom_id"], name: "index_courses_on_classroom_id"
    t.index ["school_id"], name: "index_courses_on_school_id"
    t.index ["subject_id"], name: "index_courses_on_subject_id"
    t.index ["teacher_id"], name: "index_courses_on_teacher_id"
  end

  create_table "drivers", force: :cascade do |t|
    t.text "address"
    t.datetime "created_at", null: false
    t.string "license_number", null: false
    t.string "name", null: false
    t.string "phone", null: false
    t.bigint "school_id", null: false
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.index ["school_id"], name: "index_drivers_on_school_id"
  end

  create_table "exam_results", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "exam_id", null: false
    t.string "grade"
    t.decimal "grade_point", precision: 3, scale: 2
    t.decimal "marks_obtained", precision: 6, scale: 2
    t.text "remarks"
    t.string "status", default: "pending", null: false
    t.bigint "student_id", null: false
    t.datetime "updated_at", null: false
    t.index ["exam_id"], name: "index_exam_results_on_exam_id"
    t.index ["student_id"], name: "index_exam_results_on_student_id"
  end

  create_table "exams", force: :cascade do |t|
    t.bigint "classroom_id", null: false
    t.datetime "created_at", null: false
    t.time "end_time"
    t.date "exam_date", null: false
    t.string "exam_type", default: "mid_term", null: false
    t.text "instructions"
    t.integer "max_marks", default: 100, null: false
    t.integer "pass_marks", default: 35, null: false
    t.bigint "school_id", null: false
    t.bigint "section_id"
    t.time "start_time"
    t.string "status", default: "upcoming", null: false
    t.bigint "subject_id", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["classroom_id"], name: "index_exams_on_classroom_id"
    t.index ["school_id"], name: "index_exams_on_school_id"
    t.index ["section_id"], name: "index_exams_on_section_id"
    t.index ["subject_id"], name: "index_exams_on_subject_id"
  end

  create_table "fee_collections", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, default: "0.0"
    t.decimal "amount_paid", precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.date "due_date"
    t.bigint "fee_structure_id", null: false
    t.date "paid_date"
    t.string "payment_mode"
    t.string "receipt_no"
    t.decimal "remaining_amount", precision: 10, scale: 2, default: "0.0"
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

  create_table "grade_systems", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "grade", null: false
    t.decimal "grade_point", precision: 3, scale: 2
    t.integer "max_marks", null: false
    t.integer "min_marks", null: false
    t.bigint "school_id", null: false
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.index ["school_id"], name: "index_grade_systems_on_school_id"
  end

  create_table "homework_submissions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.decimal "grade", precision: 5, scale: 2
    t.bigint "homework_id", null: false
    t.datetime "reviewed_at"
    t.string "status", default: "pending", null: false
    t.bigint "student_id", null: false
    t.text "submission_text"
    t.datetime "submitted_at"
    t.text "teacher_remarks"
    t.datetime "updated_at", null: false
    t.index ["homework_id"], name: "index_homework_submissions_on_homework_id"
    t.index ["student_id"], name: "index_homework_submissions_on_student_id"
  end

  create_table "homeworks", force: :cascade do |t|
    t.bigint "classroom_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.date "due_date", null: false
    t.bigint "school_id", null: false
    t.bigint "section_id"
    t.string "status", default: "active", null: false
    t.bigint "subject_id", null: false
    t.bigint "teacher_id", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["classroom_id"], name: "index_homeworks_on_classroom_id"
    t.index ["school_id"], name: "index_homeworks_on_school_id"
    t.index ["section_id"], name: "index_homeworks_on_section_id"
    t.index ["subject_id"], name: "index_homeworks_on_subject_id"
    t.index ["teacher_id"], name: "index_homeworks_on_teacher_id"
  end

  create_table "hostel_beds", force: :cascade do |t|
    t.string "bed_number", null: false
    t.datetime "created_at", null: false
    t.bigint "hostel_room_id", null: false
    t.string "status", default: "vacant", null: false
    t.bigint "student_id"
    t.datetime "updated_at", null: false
    t.index ["hostel_room_id"], name: "index_hostel_beds_on_hostel_room_id"
    t.index ["student_id"], name: "index_hostel_beds_on_student_id"
  end

  create_table "hostel_rooms", force: :cascade do |t|
    t.integer "capacity", default: 2, null: false
    t.datetime "created_at", null: false
    t.string "floor"
    t.string "room_number", null: false
    t.string "room_type", default: "standard", null: false
    t.bigint "school_id", null: false
    t.string "status", default: "available", null: false
    t.datetime "updated_at", null: false
    t.index ["school_id"], name: "index_hostel_rooms_on_school_id"
  end

  create_table "inventory_items", force: :cascade do |t|
    t.string "category", null: false
    t.string "condition", default: "good"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.date "purchase_date"
    t.decimal "purchase_price", precision: 12, scale: 2
    t.integer "quantity", default: 1, null: false
    t.bigint "school_id", null: false
    t.string "status", default: "active", null: false
    t.string "unit", default: "pieces"
    t.datetime "updated_at", null: false
    t.index ["school_id"], name: "index_inventory_items_on_school_id"
  end

  create_table "leave_applications", force: :cascade do |t|
    t.text "admin_remarks"
    t.string "applicant_type", default: "teacher", null: false
    t.bigint "approved_by_id"
    t.datetime "approved_on"
    t.datetime "created_at", null: false
    t.date "end_date", null: false
    t.string "leave_type", null: false
    t.text "reason", null: false
    t.bigint "school_id", null: false
    t.date "start_date", null: false
    t.string "status", default: "pending", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["approved_by_id"], name: "index_leave_applications_on_approved_by_id"
    t.index ["school_id"], name: "index_leave_applications_on_school_id"
    t.index ["user_id"], name: "index_leave_applications_on_user_id"
  end

  create_table "lesson_plans", force: :cascade do |t|
    t.string "chapter"
    t.bigint "classroom_id", null: false
    t.datetime "created_at", null: false
    t.text "learning_outcome"
    t.date "planned_date"
    t.bigint "school_id", null: false
    t.string "status"
    t.bigint "subject_id", null: false
    t.bigint "teacher_id", null: false
    t.string "topic"
    t.datetime "updated_at", null: false
    t.index ["classroom_id"], name: "index_lesson_plans_on_classroom_id"
    t.index ["school_id"], name: "index_lesson_plans_on_school_id"
    t.index ["subject_id"], name: "index_lesson_plans_on_subject_id"
    t.index ["teacher_id"], name: "index_lesson_plans_on_teacher_id"
  end

  create_table "library_books", force: :cascade do |t|
    t.string "author"
    t.integer "available_copies", default: 1, null: false
    t.string "barcode"
    t.string "category"
    t.datetime "created_at", null: false
    t.string "isbn"
    t.string "publisher"
    t.bigint "school_id", null: false
    t.string "shelf_location"
    t.string "status", default: "available", null: false
    t.string "title", null: false
    t.integer "total_copies", default: 1, null: false
    t.datetime "updated_at", null: false
    t.index ["school_id"], name: "index_library_books_on_school_id"
  end

  create_table "live_class_attendances", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "joined_at"
    t.datetime "left_at"
    t.bigint "live_class_id", null: false
    t.string "status", default: "absent", null: false
    t.bigint "student_id", null: false
    t.datetime "updated_at", null: false
    t.index ["live_class_id"], name: "index_live_class_attendances_on_live_class_id"
    t.index ["student_id"], name: "index_live_class_attendances_on_student_id"
  end

  create_table "live_classes", force: :cascade do |t|
    t.bigint "classroom_id", null: false
    t.datetime "created_at", null: false
    t.integer "duration_minutes", default: 60
    t.string "meeting_id"
    t.string "meeting_url"
    t.string "passcode"
    t.string "platform", default: "zoom", null: false
    t.string "recording_url"
    t.datetime "scheduled_at", null: false
    t.bigint "school_id", null: false
    t.bigint "section_id"
    t.string "status", default: "scheduled", null: false
    t.bigint "subject_id", null: false
    t.bigint "teacher_id", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["classroom_id"], name: "index_live_classes_on_classroom_id"
    t.index ["school_id"], name: "index_live_classes_on_school_id"
    t.index ["section_id"], name: "index_live_classes_on_section_id"
    t.index ["subject_id"], name: "index_live_classes_on_subject_id"
    t.index ["teacher_id"], name: "index_live_classes_on_teacher_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "read_at"
    t.bigint "receiver_id", null: false
    t.bigint "school_id", null: false
    t.bigint "sender_id", null: false
    t.datetime "updated_at", null: false
    t.index ["receiver_id"], name: "index_messages_on_receiver_id"
    t.index ["school_id"], name: "index_messages_on_school_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
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

  create_table "question_banks", force: :cascade do |t|
    t.text "answer_key"
    t.datetime "created_at", null: false
    t.string "difficulty"
    t.integer "marks"
    t.text "question_text"
    t.bigint "school_id", null: false
    t.bigint "subject_id", null: false
    t.bigint "teacher_id", null: false
    t.datetime "updated_at", null: false
    t.index ["school_id"], name: "index_question_banks_on_school_id"
    t.index ["subject_id"], name: "index_question_banks_on_subject_id"
    t.index ["teacher_id"], name: "index_question_banks_on_teacher_id"
  end

  create_table "quiz_attempts", force: :cascade do |t|
    t.jsonb "answers", default: {}, null: false
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.bigint "quiz_id", null: false
    t.integer "score", default: 0
    t.datetime "started_at"
    t.string "status", default: "in_progress", null: false
    t.bigint "student_id", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_id"], name: "index_quiz_attempts_on_quiz_id"
    t.index ["student_id"], name: "index_quiz_attempts_on_student_id"
  end

  create_table "quiz_questions", force: :cascade do |t|
    t.string "correct_answer", null: false
    t.datetime "created_at", null: false
    t.integer "marks", default: 1, null: false
    t.jsonb "options", default: [], null: false
    t.text "question_text", null: false
    t.string "question_type", default: "mcq", null: false
    t.bigint "quiz_id", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_id"], name: "index_quiz_questions_on_quiz_id"
  end

  create_table "quizzes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "status", default: "active", null: false
    t.integer "time_limit_minutes", default: 30
    t.string "title", null: false
    t.bigint "topic_id", null: false
    t.integer "total_marks", default: 10, null: false
    t.datetime "updated_at", null: false
    t.index ["topic_id"], name: "index_quizzes_on_topic_id"
  end

  create_table "route_stops", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.time "evening_arrival_time"
    t.time "morning_arrival_time"
    t.bigint "route_id", null: false
    t.string "stop_name", null: false
    t.integer "stop_order", default: 1, null: false
    t.datetime "updated_at", null: false
    t.index ["route_id"], name: "index_route_stops_on_route_id"
  end

  create_table "routes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "driver_id", null: false
    t.string "end_location"
    t.string "name", null: false
    t.bigint "school_id", null: false
    t.string "start_location"
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.bigint "vehicle_id", null: false
    t.index ["driver_id"], name: "index_routes_on_driver_id"
    t.index ["school_id"], name: "index_routes_on_school_id"
    t.index ["vehicle_id"], name: "index_routes_on_vehicle_id"
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

  create_table "student_parents", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "relationship", default: "father"
    t.bigint "student_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["student_id"], name: "index_student_parents_on_student_id"
    t.index ["user_id"], name: "index_student_parents_on_user_id"
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

  create_table "teacher_documents", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "doc_type"
    t.bigint "school_id", null: false
    t.bigint "teacher_id", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["school_id"], name: "index_teacher_documents_on_school_id"
    t.index ["teacher_id"], name: "index_teacher_documents_on_teacher_id"
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

  create_table "timetables", force: :cascade do |t|
    t.bigint "classroom_id", null: false
    t.datetime "created_at", null: false
    t.string "day_of_week"
    t.time "end_time"
    t.integer "period"
    t.bigint "school_id", null: false
    t.time "start_time"
    t.bigint "subject_id", null: false
    t.bigint "teacher_id", null: false
    t.datetime "updated_at", null: false
    t.index ["classroom_id"], name: "index_timetables_on_classroom_id"
    t.index ["school_id"], name: "index_timetables_on_school_id"
    t.index ["subject_id"], name: "index_timetables_on_subject_id"
    t.index ["teacher_id"], name: "index_timetables_on_teacher_id"
  end

  create_table "topics", force: :cascade do |t|
    t.bigint "chapter_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.integer "order_position", default: 1, null: false
    t.string "pdf_url"
    t.string "status", default: "active", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.string "video_url"
    t.index ["chapter_id"], name: "index_topics_on_chapter_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.string "role", default: "school_admin", null: false
    t.bigint "school_id"
    t.string "status", default: "active", null: false
    t.bigint "student_id"
    t.bigint "teacher_id"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["role"], name: "index_users_on_role"
    t.index ["school_id"], name: "index_users_on_school_id"
    t.index ["student_id"], name: "index_users_on_student_id"
    t.index ["teacher_id"], name: "index_users_on_teacher_id"
  end

  create_table "vehicles", force: :cascade do |t|
    t.integer "capacity", default: 40, null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "registration_number", null: false
    t.bigint "school_id", null: false
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.string "vehicle_type", default: "bus", null: false
    t.index ["school_id"], name: "index_vehicles_on_school_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "assignment_questions", "assignments"
  add_foreign_key "assignments", "classrooms"
  add_foreign_key "assignments", "schools"
  add_foreign_key "assignments", "subjects"
  add_foreign_key "assignments", "teachers"
  add_foreign_key "classroom_subjects", "classrooms"
  add_foreign_key "classroom_subjects", "subjects"
  add_foreign_key "classroom_subjects", "teachers"
  add_foreign_key "classrooms", "schools"
  add_foreign_key "fee_collections", "fee_structures"
  add_foreign_key "fee_collections", "students"
  add_foreign_key "fee_structures", "classrooms"
  add_foreign_key "fee_structures", "schools"
  add_foreign_key "lesson_plans", "classrooms"
  add_foreign_key "lesson_plans", "schools"
  add_foreign_key "lesson_plans", "subjects"
  add_foreign_key "lesson_plans", "teachers"
  add_foreign_key "payments", "schools"
  add_foreign_key "payments", "subscription_plans"
  add_foreign_key "question_banks", "schools"
  add_foreign_key "question_banks", "subjects"
  add_foreign_key "question_banks", "teachers"
  add_foreign_key "schools", "subscription_plans"
  add_foreign_key "sections", "classrooms"
  add_foreign_key "sections", "schools"
  add_foreign_key "student_attendances", "classrooms"
  add_foreign_key "student_attendances", "students"
  add_foreign_key "student_parents", "students"
  add_foreign_key "student_parents", "users"
  add_foreign_key "students", "classrooms"
  add_foreign_key "students", "schools"
  add_foreign_key "students", "sections"
  add_foreign_key "subjects", "schools"
  add_foreign_key "teacher_attendances", "teachers"
  add_foreign_key "teacher_documents", "schools"
  add_foreign_key "teacher_documents", "teachers"
  add_foreign_key "teachers", "schools"
  add_foreign_key "timetables", "classrooms"
  add_foreign_key "timetables", "schools"
  add_foreign_key "timetables", "subjects"
  add_foreign_key "timetables", "teachers"
  add_foreign_key "users", "schools"
  add_foreign_key "users", "students"
  add_foreign_key "users", "teachers"
end
