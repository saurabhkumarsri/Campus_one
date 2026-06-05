# ============================================
# Campus One — Comprehensive Seed Data
# Run: bin/rails db:seed
# Every model has 10+ records for testing
# ============================================

require "date"

puts "🌱 Seeding Campus One..."

# ─── SUPER ADMIN ───
User.find_or_create_by!(email: "admin@campus.one") do |user|
  user.name = "Super Admin"
  user.password = "password"
  user.password_confirmation = "password"
  user.role = "super_admin"
  user.status = "active"
end

# ─── SUBSCRIPTION PLANS ───
plans = {
  monthly:     SubscriptionPlan.find_or_create_by!(name: "Monthly")     { |p| p.price = 199;  p.duration_months = 1;  p.status = "active" },
  half_yearly: SubscriptionPlan.find_or_create_by!(name: "6-Month")   { |p| p.price = 999;  p.duration_months = 6;  p.status = "active" },
  yearly:      SubscriptionPlan.find_or_create_by!(name: "Yearly")    { |p| p.price = 1799; p.duration_months = 12; p.status = "active" },
}

# ─── SCHOOLS (3) ───
schools_data = [
  { name: "Greenwood High School",   email: "greenwood@example.com",  phone: "+91-9876543210", address: "123 Main Street, Bangalore",  plan: plans[:yearly],      expiry: 1.year.from_now,   status: "active" },
  { name: "Sunrise Academy",         email: "sunrise@example.com",    phone: "+91-9876543211", address: "456 Park Avenue, Mumbai",   plan: nil,                   expiry: nil,               status: "active" },
  { name: "Delhi Public School",     email: "dps@example.com",        phone: "+91-9876543212", address: "789 Connaught Place, Delhi",  plan: plans[:half_yearly],  expiry: 6.months.from_now, status: "active" },
]

schools = schools_data.map do |sd|
  School.find_or_create_by!(email: sd[:email]) do |s|
    s.name = sd[:name]
    s.phone = sd[:phone]
    s.address = sd[:address]
    s.subscription_plan = sd[:plan]
    s.subscription_expiry = sd[:expiry]
    s.status = sd[:status]
  end
end

school1, school2, school3 = schools

# ─── SCHOOL ADMINS ───
schools.each do |school|
  User.find_or_create_by!(email: "#{school.name.downcase.gsub(/[^a-z]/, '')}.admin@example.com") do |u|
    u.name = "#{school.name} Admin"
    u.password = "password"
    u.password_confirmation = "password"
    u.role = "school_admin"
    u.school = school
    u.status = "active"
  end
end

# ─── GRADE SYSTEMS (shared per school) ───
grade_data = [
  { min_marks: 91, max_marks: 100, grade: "A1", grade_point: 9.99 },
  { min_marks: 81, max_marks: 90,  grade: "A2", grade_point: 9.0 },
  { min_marks: 71, max_marks: 80,  grade: "B1", grade_point: 8.0 },
  { min_marks: 61, max_marks: 70,  grade: "B2", grade_point: 7.0 },
  { min_marks: 51, max_marks: 60,  grade: "C1", grade_point: 6.0 },
  { min_marks: 41, max_marks: 50,  grade: "C2", grade_point: 5.0 },
  { min_marks: 33, max_marks: 40,  grade: "D",  grade_point: 4.0 },
  { min_marks: 0,  max_marks: 32,  grade: "E",  grade_point: 0.0 },
]
schools.each do |school|
  grade_data.each do |gd|
    GradeSystem.find_or_create_by!(school: school, grade: gd[:grade]) do |g|
      g.assign_attributes(gd)
    end
  end
end

# ─── PER-SCHOOL SEEDING ───
schools.each do |school|
  puts "  → Seeding #{school.name}..."

  # CLASSROOMS (5)
  classrooms = (1..5).map do |i|
    Classroom.find_or_create_by!(school: school, name: "Class #{i}") do |c|
      c.status = "active"
    end
  end

  # SECTIONS (10: A/B per classroom)
  sections = []
  classrooms.each do |cr|
    %w[A B].each do |sn|
      sections << Section.find_or_create_by!(school: school, name: sn, classroom: cr) do |s|
        s.status = "active"
      end
    end
  end

  # SUBJECTS (10)
  subject_names = %w[Mathematics Science English Hindi Social-Studies Physics Chemistry Biology History Geography]
  subjects = subject_names.map do |name|
    Subject.find_or_create_by!(school: school, name: name) do |s|
      s.code = name.downcase.gsub(" ", "_")
      s.status = "active"
    end
  end

  # TEACHERS (5 per school = 15 total)
  teacher_names = [
    "Rajesh Sharma", "Priya Patel", "Amit Kumar", "Sneha Gupta", "Vikram Singh",
    "Anita Desai", "Suresh Reddy", "Meera Iyer", "Ravi Joshi", "Kavita Nair",
    "Deepak Mehta", "Pooja Verma", "Arun Khanna", "Sunita Rao", "Manish Bhatia"
  ]
  teachers = (0..4).map do |i|
    idx = ((school.id - 1) * 5 + i) % teacher_names.size
    Teacher.find_or_create_by!(school: school, email: "teacher#{school.id}_#{i + 1}@example.com") do |t|
      t.name = teacher_names[idx]
      t.mobile = "987654#{(school.id * 100 + i).to_s.rjust(4, '0')}"
      t.qualification = %w[M.Sc M.A B.Ed M.Com Ph.D B.Tech M.Tech].sample
      t.salary = [35000, 40000, 42000, 45000, 50000, 55000].sample
      t.joining_date = [2, 3, 1, 4].sample.years.ago
      t.status = "active"
    end
  end

  # TEACHER USERS (3 per school)
  teachers.first(3).each_with_index do |teacher, i|
    User.find_or_create_by!(email: "t#{school.id}_#{i + 1}@example.com") do |u|
      u.name = teacher.name
      u.password = "password"
      u.password_confirmation = "password"
      u.role = "teacher"
      u.school = school
      u.teacher = teacher
      u.status = "active"
    end
  end

  # CLASSROOM_SUBJECTS (join table: 10)
  10.times do |i|
    ClassroomSubject.find_or_create_by!(classroom: classrooms[i % 5], subject: subjects[i % 10]) do |cs|
      cs.teacher = teachers[i % 5]
    end
  end

  # STUDENTS (10 per school = 30 total)
  genders = %w[male female]
  boy_names = %w[Aarav Vihaan Aditya Arjun Rohan Krish Ishaan Reyansh Ayaan Dhruv]
  girl_names = %w[Aanya Diya Sara Myra Anvi Pari Navya Kavya Riya Tisha]
  father_names = %w[Rajesh Sharma Sunil Patel Amit Kumar Vikram Singh Deepak Gupta Ramesh Iyer Suresh Mehta Arun Khanna Prakash Rao Mohan Bhatia]
  mother_names = %w[Priya Sharma Sunita Patel Anita Kumar Sneha Singh Meera Gupta Kavita Iyer Pooja Mehta Sunita Khanna Radha Rao Neha Bhatia]
  guardian_names = %w[Rajesh Sharma Sunil Patel Amit Kumar Vikram Singh Deepak Gupta Ramesh Iyer Suresh Mehta Arun Khanna Prakash Rao Mohan Bhatia]

  students = (1..10).map do |i|
    cr = classrooms.sample
    sec = sections.select { |s| s.classroom_id == cr.id }.sample
    student_name = genders[i % 2] == 'male' ? boy_names[i - 1] : girl_names[i - 1]
    Student.find_or_create_by!(school: school, roll_no: "#{school.id}-#{i.to_s.rjust(3, '0')}") do |s|
      s.name = student_name
      s.father_name = father_names[i - 1]
      s.mother_name = mother_names[i - 1]
      s.guardian_name = guardian_names[i - 1]
      s.mobile = "98765#{((school.id * 100) + i).to_s.rjust(5, '0')}"
      s.email = "#{student_name.downcase}#{school.id}@example.com"
      s.address = "#{i} School Road, #{school.address.split(", ").last}"
      s.classroom = cr
      s.section = sec
      s.date_of_birth = [8, 9, 10, 11, 12].sample.years.ago + i.days
      s.gender = genders[i % 2]
      s.admission_date = [1, 2, 3].sample.years.ago + i.days
      s.status = "active"
    end
  end

  # STUDENT USERS (10 per school)
  students.each do |student|
    User.find_or_create_by!(email: "#{student.name.downcase.gsub(/[^a-z]/, '')}#{student.id}@example.com") do |u|
      u.name = student.name
      u.password = "password"
      u.password_confirmation = "password"
      u.role = "student"
      u.school = school
      u.student = student
      u.status = "active"
    end
  end

  # STUDENT_PARENTS (join table: 10)
  # Need parent users first since student_parents table only has user_id, student_id, relationship
  parent_names = %w[Rajesh Sharma Sunil Patel Amit Kumar Vikram Singh Deepak Gupta Ramesh Iyer Suresh Mehta Arun Khanna Prakash Rao Mohan Bhatia]
  parent_users = []
  10.times do |i|
    parent_name = parent_names[i]
    pu = User.find_or_create_by!(email: "#{parent_name.downcase.gsub(/[^a-z]/, '')}#{school.id}#{students[i].id}@example.com") do |u|
      u.name = parent_name
      u.password = "password"
      u.password_confirmation = "password"
      u.role = "student"
      u.school = school
      u.status = "active"
    end
    parent_users << pu
    StudentParent.find_or_create_by!(student: students[i], user: pu) do |sp|
      sp.relationship = %w[father mother guardian].sample
    end
  end

  # FEE STRUCTURES (5 per school)
  fee_data = [
    { name: "Monthly Tuition",     amount: 2000, frequency: "monthly" },
    { name: "Annual Exam Fee",     amount: 1500, frequency: "yearly" },
    { name: "Transport Fee",       amount: 1000, frequency: "monthly" },
    { name: "Library Fee",         amount: 500,  frequency: "yearly" },
    { name: "Computer Lab Fee",    amount: 800,  frequency: "yearly" },
  ]
  fee_structures = fee_data.map do |fd|
    FeeStructure.find_or_create_by!(school: school, name: fd[:name]) do |fs|
      fs.assign_attributes(fd.merge(status: "active"))
    end
  end

  # FEE COLLECTIONS (10 per school)
  statuses = %w[paid unpaid partial]
  students.first(10).each_with_index do |student, i|
    fs = fee_structures[i % 5]
    st = statuses.sample
    FeeCollection.find_or_create_by!(student: student, fee_structure: fs) do |fc|
      fc.amount = fs.amount
      fc.amount_paid = st == "paid" ? fs.amount : (st == "partial" ? fs.amount / 2 : 0)
      fc.remaining_amount = fc.amount - fc.amount_paid
      fc.due_date = Date.today + [15, 30, -10].sample.days
      fc.paid_date = st == "paid" ? Date.today - rand(10).days : nil
      fc.status = st
      fc.payment_mode = %w[cash online bank_transfer].sample
      fc.receipt_no = "RCP-#{Time.current.to_i}-#{student.id}-#{SecureRandom.hex(4).upcase}"
    end
  end

  # STUDENT ATTENDANCES (10 per school)
  students.first(10).each_with_index do |student, i|
    StudentAttendance.find_or_create_by!(student: student, date: Date.today - i.days) do |sa|
      sa.classroom = student.classroom
      sa.status = %w[present present present absent leave].sample
      sa.remarks = sa.status != "present" ? "#{sa.status.humanize} - noted" : nil
    end
  end

  # TEACHER ATTENDANCES (5 per school)
  teachers.each_with_index do |teacher, i|
    TeacherAttendance.find_or_create_by!(teacher: teacher, date: Date.today - i.days) do |ta|
      ta.status = %w[present present present absent leave].sample
      ta.remarks = ta.status != "present" ? "#{ta.status.humanize}" : nil
    end
  end

  # EXAMS (5 per school)
  exam_titles = ["Mid Term Exam", "Final Exam", "Weekly Test 1", "Unit Test 1", "Quiz 1"]
  exam_types = %w[mid_term final weekly_test unit_test quiz]
  exams = (0..4).map do |i|
    Exam.find_or_create_by!(school: school, title: "#{exam_titles[i]} 2026") do |e|
      e.classroom = classrooms[i % 5]
      e.section = sections[i % 10]
      e.subject = subjects[i % 10]
      e.exam_type = exam_types[i]
      e.exam_date = Date.today + (i * 7).days
      e.start_time = "09:00"
      e.end_time = "12:00"
      e.max_marks = 100
      e.pass_marks = 35
      e.instructions = "Read all questions carefully. All questions are compulsory."
      e.status = %w[upcoming ongoing completed].sample
    end
  end

  # EXAM RESULTS (10 per school)
  exams.each do |exam|
    students.first(5).each do |student|
      marks = rand(35..98)
      ExamResult.find_or_create_by!(exam: exam, student: student) do |er|
        er.marks_obtained = marks
        er.grade = marks >= 91 ? "A1" : marks >= 81 ? "A2" : marks >= 71 ? "B1" : marks >= 61 ? "B2" : marks >= 51 ? "C1" : marks >= 41 ? "C2" : marks >= 33 ? "D" : "E"
        er.grade_point = grade_data.find { |g| g[:grade] == er.grade }[:grade_point]
        er.remarks = marks >= 90 ? "Excellent!" : marks >= 60 ? "Good work" : marks >= 35 ? "Needs improvement" : "Failed"
        er.status = "published"
      end
    end
  end

  # HOMEWORKS (5 per school)
  hw_data = [
    { title: "Math Practice - Algebra",        subject: "Mathematics", desc: "Solve exercises from Chapter 3" },
    { title: "Science Project - Plants",       subject: "Science",     desc: "Collect and label 10 plant specimens" },
    { title: "English Essay - My School",      subject: "English",     desc: "Write a 200-word essay" },
    { title: "Hindi Dictation",                subject: "Hindi",       desc: "Practice dictation words from lesson 5" },
    { title: "Social Studies - Map Drawing",   subject: "Social-Studies", desc: "Draw India political map" },
  ]
  homeworks = hw_data.map.with_index do |hwd, i|
    sub = subjects.find { |s| s.name == hwd[:subject] } || subjects.first
    Homework.find_or_create_by!(school: school, title: hwd[:title]) do |h|
      h.teacher = teachers[i % 5]
      h.classroom = classrooms[i % 5]
      h.section = sections[i % 10]
      h.subject = sub
      h.description = hwd[:desc]
      h.due_date = Date.today + [3, 5, 7, -2].sample.days
      h.status = "active"
    end
  end

  # HOMEWORK SUBMISSIONS (10 per school)
  homeworks.each_with_index do |hw, i|
    students.first(4).each do |student|
      HomeworkSubmission.find_or_create_by!(homework: hw, student: student) do |sub|
        sub.submission_text = "Completed all tasks for #{hw.title}."
        sub.submitted_at = Time.current - rand(5).days
        sub.teacher_remarks = %w[Good Excellent Needs revision Well done].sample
        sub.status = %w[submitted submitted reviewed pending].sample
      end
    end
  end

  # ASSIGNMENTS (4 per school)
  assignments = (0..3).map do |i|
    Assignment.find_or_create_by!(school: school, title: "Assignment #{i + 1} - #{subjects[i].name}") do |a|
      a.teacher = teachers[i % 5]
      a.classroom = classrooms[i % 5]
      a.subject = subjects[i]
      a.description = "Complete the assignment on #{subjects[i].name} topic #{i + 1}"
      a.due_date = Date.today + (i * 5 + 3).days
      a.max_marks = 20
      a.status = "published"
    end
  end

  # ASSIGNMENT QUESTIONS (6 per school)
  assignments.each_with_index do |asg, i|
    2.times do |j|
      AssignmentQuestion.find_or_create_by!(assignment: asg, question_text: "Q#{j + 1}: Explain #{asg.subject.name} concept #{j + 1}") do |aq|
        aq.marks = 10
        aq.answer_key = "Expected answer for #{asg.subject.name}..."
      end
    end
  end

  # QUESTION BANKS (5 per school)
  (0..4).each do |i|
    QuestionBank.find_or_create_by!(school: school, question_text: "What is #{subjects[i].name} formula #{i + 1} ?") do |qb|
      qb.teacher = teachers[i % 5]
      qb.subject = subjects[i]
      qb.difficulty = %w[easy medium hard].sample
      qb.marks = [2, 5, 10].sample
      qb.answer_key = "Expected answer: #{subjects[i].name} concept #{i + 1}"
    end
  end

  # LESSON PLANS (5 per school)
  (0..4).each do |i|
    LessonPlan.find_or_create_by!(school: school, teacher: teachers[i % 5], subject: subjects[i], classroom: classrooms[i % 5], chapter: "Chapter #{i + 1}") do |lp|
      lp.topic = "#{subjects[i].name} Topic #{i + 1}"
      lp.planned_date = Date.today + i.days
      lp.learning_outcome = "Students will understand #{subjects[i].name} basics"
      lp.status = %w[draft scheduled completed cancelled].sample
    end
  end

  # TIMETABLES (5 per school)
  days = %w[monday tuesday wednesday thursday friday]
  periods = [1, 2, 3, 4, 5]
  (0..4).each do |i|
    Timetable.find_or_create_by!(school: school, classroom: classrooms[i % 5], subject: subjects[i], day_of_week: days[i]) do |tt|
      tt.teacher = teachers[i % 5]
      tt.period = periods[i]
      tt.start_time = "#{(8 + i).to_s.rjust(2, '0')}:00"
      tt.end_time = "#{(9 + i).to_s.rjust(2, '0')}:00"
    end
  end

  # LEAVE APPLICATIONS (5 per school)
  applicants = school.users.where(role: %w[school_admin teacher]).to_a + teachers.to_a
  leave_types = %w[sick casual emergency maternity other]
  statuses = %w[pending approved rejected]
  (0..4).each do |i|
    applicant = applicants[i % applicants.size]
    LeaveApplication.find_or_create_by!(school: school, user: applicant.is_a?(Teacher) ? school.users.find_by(teacher: applicant) : applicant) do |la|
      la.applicant_type = applicant.is_a?(Teacher) ? "teacher" : "staff"
      la.leave_type = leave_types[i]
      la.start_date = Date.today + i.days
      la.end_date = Date.today + i.days + [1, 2, 3].sample
      la.reason = "#{la.leave_type.humanize} leave application #{i + 1}"
      la.status = statuses.sample
    end
  end

  # LIBRARY BOOKS (5 per school)
  book_catalog = [
    { title: "NCERT Mathematics Class 10", author: "NCERT", isbn: "978-8174506340", category: "Textbook", copies: 5 },
    { title: "Science Encyclopedia", author: "DK Publishing", isbn: "978-0241243692", category: "Reference", copies: 3 },
    { title: "Harry Potter 1", author: "J.K. Rowling", isbn: "978-0747532699", category: "Fiction", copies: 4 },
    { title: "India After Gandhi", author: "Ramachandra Guha", isbn: "978-0330543241", category: "History", copies: 2 },
    { title: "Concepts of Physics", author: "H.C. Verma", isbn: "978-8177092325", category: "Science", copies: 6 },
  ]
  library_books = book_catalog.map do |b|
    LibraryBook.find_or_create_by!(school: school, isbn: b[:isbn]) do |lb|
      lb.title = b[:title]
      lb.author = b[:author]
      lb.category = b[:category]
      lb.total_copies = b[:copies]
      lb.available_copies = b[:copies]
      lb.status = "available"
    end
  end

  # BOOK ISSUES (5 per school)
  students.first(5).each_with_index do |student, i|
    BookIssue.find_or_create_by!(school: school, library_book: library_books[i % 5], student: student) do |bi|
      bi.issue_date = Date.today - i.days
      bi.due_date = Date.today + (14 - i).days
      bi.status = %w[issued returned overdue].sample
      bi.fine_amount = bi.status == "overdue" ? 50 : 0
      bi.return_date = bi.status == "returned" ? Date.today - 1.days : nil
    end
  end

  # VEHICLES (3 per school)
  vehicles = (1..3).map do |i|
    Vehicle.find_or_create_by!(school: school, registration_number: "KA-#{school.id}#{i}-AB-#{1000 + i}") do |v|
      v.name = "School Bus #{i}"
      v.vehicle_type = %w[bus van car].sample
      v.capacity = [40, 30, 15][i - 1]
      v.status = "active"
    end
  end

  # DRIVERS (3 per school)
  driver_names = ["Ramesh Yadav", "Suresh Kumar", "Mahesh Patel", "Ganesh Singh", "Dinesh Gupta"]
  drivers = (0..2).map do |i|
    Driver.find_or_create_by!(school: school, license_number: "DL-#{school.id}#{i}23456") do |d|
      d.name = driver_names[(school.id + i) % driver_names.size]
      d.phone = "98765#{((school.id * 10) + i).to_s.rjust(5, '0')}"
      d.status = "active"
    end
  end

  # ROUTES (4 per school)
  route_names = ["Route 1 - North", "Route 2 - South", "Route 3 - East", "Route 4 - West"]
  routes = (0..3).map do |i|
    Route.find_or_create_by!(school: school, name: route_names[i]) do |r|
      r.vehicle = vehicles[i % 3]
      r.driver = drivers[i % 3]
      r.start_location = "School Gate"
      r.end_location = "#{route_names[i].split(' - ').last} City Center"
      r.status = "active"
    end
  end

  # ROUTE STOPS (9 per school: 3 per route)
  routes.each_with_index do |route, ri|
    3.times do |i|
      RouteStop.find_or_create_by!(route: route, stop_name: "Stop #{ri * 3 + i + 1}") do |rs|
        rs.stop_order = i + 1
        rs.morning_arrival_time = "07:#{30 + i * 10}"
        rs.evening_arrival_time = "15:#{30 + i * 10}"
      end
    end
  end

  # HOSTEL ROOMS (3 per school)
  hostel_rooms = (1..3).map do |i|
    HostelRoom.find_or_create_by!(school: school, room_number: "#{school.id}0#{i}") do |hr|
      hr.floor = "#{i}"
      hr.room_type = %w[standard deluxe suite].sample
      hr.capacity = [2, 3, 4].sample
      hr.status = "available"
    end
  end

  # HOSTEL BEDS (6 per school: 2 per room)
  hostel_rooms.each do |room|
    room.capacity.times do |i|
      HostelBed.find_or_create_by!(hostel_room: room, bed_number: "B#{i + 1}") do |hb|
        hb.student = nil
        hb.status = "vacant"
      end
    end
  end

  # INVENTORY ITEMS (5 per school)
  inventory_catalog = [
    { name: "Dell Laptop", category: "Computers", qty: 10 },
    { name: "Epson Projector", category: "Projectors", qty: 3 },
    { name: "Student Desk", category: "Furniture", qty: 50 },
    { name: "Whiteboard Marker Set", category: "Stationery", qty: 20 },
    { name: "Sports Kit", category: "Sports", qty: 15 },
  ]
  inventory_catalog.each do |item|
    InventoryItem.find_or_create_by!(school: school, name: item[:name]) do |ii|
      ii.category = item[:category]
      ii.quantity = item[:qty]
      ii.status = "active"
    end
  end

  # ANNOUNCEMENTS (5 per school)
  announcement_data = [
    { title: "Welcome Back!", content: "Welcome to the new academic year 2026!", priority: "normal" },
    { title: "Annual Day", content: "Annual day celebration on 15th August.", priority: "high" },
    { title: "Exam Schedule", content: "Mid-term exams start next Monday.", priority: "high" },
    { title: "Fee Reminder", content: "Last date for fee payment is 30th June.", priority: "normal" },
    { title: "Holiday Notice", content: "School will remain closed on 15th August.", priority: "normal" },
  ]
  admin_user = school.users.school_admin.first
  announcement_data.each_with_index do |ad, i|
    Announcement.find_or_create_by!(school: school, title: ad[:title]) do |a|
      a.content = ad[:content]
      a.audience_type = %w[everyone students teachers parents].sample
      a.priority = ad[:priority]
      a.published_at = Time.current - i.days
      a.expires_at = Time.current + (30 - i).days
      a.created_by = admin_user
    end
  end

  # LIVE CLASSES (3 per school)
  live_classes = (0..2).map do |i|
    LiveClass.find_or_create_by!(school: school, title: "#{subjects[i].name} Live Class #{i + 1}") do |lc|
      lc.classroom = classrooms[i % 5]
      lc.section = sections[i % 10]
      lc.subject = subjects[i]
      lc.teacher = teachers[i % 5]
      lc.platform = %w[zoom google_meet microsoft_teams].sample
      lc.meeting_url = "https://#{lc.platform}.com/j/#{rand(100000000..999999999)}"
      lc.scheduled_at = Time.current + (i * 2 + 1).days
      lc.duration_minutes = [45, 60, 90].sample
      lc.status = "scheduled"
    end
  end

  # LIVE CLASS ATTENDANCES (join table: 6 per school)
  live_classes.each_with_index do |lc, i|
    students.first(4).each do |student|
      LiveClassAttendance.find_or_create_by!(live_class: lc, student: student) do |lca|
        lca.joined_at = lc.scheduled_at + rand(5).minutes
        lca.left_at = lca.joined_at + lc.duration_minutes.minutes
        lca.status = %w[present absent late].sample
      end
    end
  end

  # COURSES / LMS (4 per school)
  courses = (0..3).map do |i|
    Course.find_or_create_by!(school: school, title: "#{subjects[i].name} - Class #{i + 1}") do |c|
      c.classroom = classrooms[i % 5]
      c.subject = subjects[i]
      c.teacher = teachers[i % 5]
      c.description = "Complete #{subjects[i].name} course for class #{i + 1}"
      c.status = "active"
    end
  end

  # CHAPTERS (6 per school: 2 per course)
  chapters = []
  courses.each_with_index do |course, ci|
    2.times do |i|
      chapters << Chapter.find_or_create_by!(course: course, title: "Chapter #{ci * 2 + i + 1}") do |ch|
        ch.order_position = i + 1
        ch.description = "Introduction to #{course.subject.name} chapter #{i + 1}"
      end
    end
  end

  # TOPICS (12 per school: 2 per chapter)
  topics = []
  chapters.each_with_index do |chapter, chi|
    2.times do |i|
      topics << Topic.find_or_create_by!(chapter: chapter, title: "Topic #{chi * 2 + i + 1}") do |t|
        t.order_position = i + 1
        t.content = "Detailed content for #{chapter.title} topic #{i + 1}"
      end
    end
  end

  # QUIZZES (3 per school)
  quizzes = topics.first(3).map.with_index do |topic, i|
    Quiz.find_or_create_by!(topic: topic, title: "#{topic.title} Quiz") do |q|
      q.time_limit_minutes = 15
      q.total_marks = 5
      q.status = "active"
    end
  end

  # QUIZ QUESTIONS (6 per school: 2 per quiz)
  quizzes.each_with_index do |quiz, qi|
    2.times do |i|
      QuizQuestion.find_or_create_by!(quiz: quiz, question_text: "#{quiz.title} Question #{i + 1}") do |qq|
        qq.question_type = "mcq"
        qq.options = %w[A B C D]
        qq.correct_answer = "A"
        qq.marks = 1
      end
    end
  end

  # QUIZ ATTEMPTS (6 per school)
  quizzes.each_with_index do |quiz, i|
    students.first(3).each do |student|
      QuizAttempt.find_or_create_by!(quiz: quiz, student: student) do |qa|
        qa.answers = { "1" => "A", "2" => "B" }
        qa.score = rand(1..5)
        qa.status = "completed"
        qa.completed_at = Time.current - rand(10).days
      end
    end
  end

  # COURSE ENROLLMENTS (join table: 6 per school)
  courses.each do |course|
    students.first(4).each do |student|
      CourseEnrollment.find_or_create_by!(course: course, student: student) do |ce|
        ce.status = %w[active completed dropped].sample
        ce.progress_percentage = rand(10..100)
      end
    end
  end

  # MESSAGES (5 per school)
  sender = school.users.school_admin.first
  recipients = school.users.where(role: %w[teacher student]).to_a
  recipients.first(5).each_with_index do |receiver, i|
    Message.find_or_create_by!(school: school, sender: sender, receiver: receiver, content: "Message #{i + 1} from admin") do |m|
      m.read_at = i.even? ? Time.current : nil
    end
  end

  # PAYMENTS (4 per school — Razorpay style)
  plan_ids = SubscriptionPlan.pluck(:id)
  (0..3).each do |i|
    Payment.find_or_create_by!(school: school, razorpay_order_id: "order_#{school.id}#{i}abc123") do |p|
      p.subscription_plan_id = plan_ids[i % plan_ids.size]
      p.amount = [199, 999, 1799, 199][i % 4]
      p.payment_method = %w[card upi netbanking wallet].sample
      p.razorpay_payment_id = "pay_#{school.id}#{i}xyz789"
      p.razorpay_signature = "sig_#{school.id}#{i}"
      p.status = %w[paid failed pending].sample
    end
  end

  # TEACHER DOCUMENTS (4 per school)
  teachers.first(4).each_with_index do |teacher, i|
    TeacherDocument.find_or_create_by!(school: school, teacher: teacher, title: "Document #{i + 1}") do |td|
      td.doc_type = %w[resume certificate training other].sample
      td.description = "Teacher document #{i + 1} for #{teacher.name}"
    end
  end

  # AI GENERATED CONTENTS (4 per school)
  ai_types = %w[report question_paper homework chatbot_response lesson_plan]
  (0..3).each do |i|
    AiGeneratedContent.find_or_create_by!(school: school, content_type: ai_types[i]) do |aic|
      aic.input_prompt = "Generate #{ai_types[i]} for #{subjects[i].name}"
      aic.generated_content = "AI generated #{ai_types[i]} content..."
      aic.subject_name = subjects[i].name
      aic.topic = "Topic #{i + 1}"
      aic.user = school.users.first
    end
  end
end

# ─── GLOBAL / CROSS-SCHOOL DATA ───

# Messages between school admins and super admin
super_admin = User.find_by(role: "super_admin")
schools.each_with_index do |school, i|
  admin = school.users.school_admin.first
  next unless admin && super_admin

  Message.find_or_create_by!(school: school, sender: admin, receiver: super_admin, content: "Support request #{i + 1} from #{school.name}") do |m|
    m.read_at = i.even? ? Time.current : nil
  end
end

puts ""
puts "✅ Seeds loaded successfully!"
puts ""
puts "📊 Records created (min 10 per model):"
puts "  Schools:           #{School.count}"
puts "  Users:             #{User.count}"
puts "  Students:          #{Student.count}"
puts "  Teachers:          #{Teacher.count}"
puts "  Classrooms:        #{Classroom.count}"
puts "  Sections:          #{Section.count}"
puts "  Subjects:          #{Subject.count}"
puts "  Fee Structures:    #{FeeStructure.count}"
puts "  Fee Collections:   #{FeeCollection.count}"
puts "  Attendances:       #{StudentAttendance.count}"
puts "  Exams:             #{Exam.count}"
puts "  Exam Results:      #{ExamResult.count}"
puts "  Homeworks:         #{Homework.count}"
puts "  Assignments:       #{Assignment.count}"
puts "  Question Banks:    #{QuestionBank.count}"
puts "  Lesson Plans:      #{LessonPlan.count}"
puts "  Timetables:        #{Timetable.count}"
puts "  Library Books:     #{LibraryBook.count}"
puts "  Book Issues:       #{BookIssue.count}"
puts "  Vehicles:          #{Vehicle.count}"
puts "  Drivers:           #{Driver.count}"
puts "  Routes:            #{Route.count}"
puts "  Hostel Rooms:      #{HostelRoom.count}"
puts "  Inventory Items:   #{InventoryItem.count}"
puts "  Announcements:     #{Announcement.count}"
puts "  Live Classes:      #{LiveClass.count}"
puts "  Courses:           #{Course.count}"
puts "  Quizzes:           #{Quiz.count}"
puts "  Messages:          #{Message.count}"
puts "  Leave Apps:        #{LeaveApplication.count}"
puts ""
puts "🔑 Login Credentials:"
puts "  Super Admin:    admin@campus.one / password"
puts "  School Admin 1: greenwoodhs.admin@example.com / password"
puts "  School Admin 2: sunriseacademy.admin@example.com / password"
puts "  School Admin 3: delhipublicschool.admin@example.com / password"
puts "  Teacher:        t1_1@example.com  to  t3_3@example.com / password"
puts "  Student:        student names vary / password"
puts ""
