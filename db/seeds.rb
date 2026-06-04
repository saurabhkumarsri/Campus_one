# Create Super Admin
User.find_or_create_by!(email: "admin@campus.one") do |user|
  user.name = "Super Admin"
  user.password = "password"
  user.password_confirmation = "password"
  user.role = "super_admin"
  user.status = "active"
end

# Create Subscription Plans - Monthly, 6-Month, Yearly
plan_monthly = SubscriptionPlan.find_or_create_by!(name: "Monthly") do |plan|
  plan.price = 199
  plan.duration_months = 1
  plan.status = "active"
end

plan_half_yearly = SubscriptionPlan.find_or_create_by!(name: "6-Month") do |plan|
  plan.price = 999
  plan.duration_months = 6
  plan.status = "active"
end

plan_yearly = SubscriptionPlan.find_or_create_by!(name: "Yearly") do |plan|
  plan.price = 1799
  plan.duration_months = 12
  plan.status = "active"
end

# Create Schools
# School 1: Active subscription
school1 = School.find_or_create_by!(email: "greenwood@example.com") do |s|
  s.name = "Greenwood High School"
  s.phone = "+91-9876543210"
  s.address = "123 Main Street, Bangalore"
  s.subscription_plan = plan_yearly
  s.subscription_expiry = 1.year.from_now
  s.status = "active"
end

# School 2: Expired subscription (so admin can test subscription flow)
school2 = School.find_or_create_by!(email: "sunrise@example.com") do |s|
  s.name = "Sunrise Academy"
  s.phone = "+91-9876543211"
  s.address = "456 Park Avenue, Mumbai"
  s.subscription_plan = nil
  s.subscription_expiry = nil
  s.status = "active"
end

# Create School Admins
User.find_or_create_by!(email: "greenwood.admin@example.com") do |user|
  user.name = "Greenwood Admin"
  user.password = "password"
  user.password_confirmation = "password"
  user.role = "school_admin"
  user.school = school1
  user.status = "active"
end

User.find_or_create_by!(email: "sunrise.admin@example.com") do |user|
  user.name = "Sunrise Admin"
  user.password = "password"
  user.password_confirmation = "password"
  user.role = "school_admin"
  user.school = school2
  user.status = "active"
end

# Helper to seed per school
receipt_counter = 0
[School.first, School.second].compact.each do |school|
  next unless school

  # Classrooms
  classes = %w[Class-1 Class-2 Class-3 Class-4 Class-5]
  classrooms = classes.map do |name|
    Classroom.find_or_create_by!(school: school, name: name) do |c|
      c.status = "active"
    end
  end

  # Sections
  sections = []
  classrooms.each do |classroom|
    %w[A B].each do |section_name|
      sections << Section.find_or_create_by!(school: school, name: section_name, classroom: classroom) do |s|
        s.status = "active"
      end
    end
  end

  # Subjects
  subjects = %w[Mathematics Science English Hindi Social-Studies].map do |name|
    Subject.find_or_create_by!(school: school, name: name) do |s|
      s.code = name.downcase.gsub(" ", "_")
      s.status = "active"
    end
  end

  # Teachers
  teachers = [
    { name: "Rajesh Sharma", email: "rajesh.#{school.id}@example.com", mobile: "9876543210", qualification: "M.Sc", salary: 45000 },
    { name: "Priya Patel", email: "priya.#{school.id}@example.com", mobile: "9876543211", qualification: "M.A", salary: 42000 },
    { name: "Amit Kumar", email: "amit.#{school.id}@example.com", mobile: "9876543212", qualification: "B.Ed", salary: 40000 },
    { name: "Sneha Gupta", email: "sneha.#{school.id}@example.com", mobile: "9876543213", qualification: "M.Com", salary: 43000 },
    { name: "Vikram Singh", email: "vikram.#{school.id}@example.com", mobile: "9876543214", qualification: "Ph.D", salary: 50000 },
  ].map do |attrs|
    Teacher.find_or_create_by!(school: school, email: attrs[:email]) do |t|
      t.assign_attributes(attrs.merge(status: "active", joining_date: 2.years.ago))
    end
  end

  # Teacher Users
  teachers.first(3).each_with_index do |teacher, i|
    User.find_or_create_by!(email: "teacher#{i + 1}@example.com") do |u|
      u.name = teacher.name
      u.password = "password"
      u.password_confirmation = "password"
      u.role = "teacher"
      u.school = school
      u.teacher = teacher
      u.status = "active"
    end
  end

  # Students
  students = []
  20.times do |i|
    classroom = classrooms.sample
    section = sections.select { |s| s.classroom_id == classroom.id }.sample
    students << Student.find_or_create_by!(school: school, roll_no: "#{school.id}-#{i + 1}") do |s|
      s.name = "Student #{i + 1}"
      s.father_name = "Father #{i + 1}"
      s.mother_name = "Mother #{i + 1}"
      s.mobile = "9876543#{100 + i}"
      s.address = "Address #{i + 1}"
      s.classroom = classroom
      s.section = section
      s.date_of_birth = 10.years.ago + i.days
      s.gender = i.even? ? "male" : "female"
      s.admission_date = 1.year.ago + i.days
      s.status = "active"
    end
  end

  # Fee Structures
  fee_structures = [
    { name: "Monthly Tuition", amount: 2000, frequency: "monthly" },
    { name: "Annual Exam Fee", amount: 1500, frequency: "yearly" },
    { name: "Transport Fee", amount: 1000, frequency: "monthly" },
  ].map do |attrs|
    FeeStructure.find_or_create_by!(school: school, name: attrs[:name]) do |fs|
      fs.assign_attributes(attrs.merge(status: "active"))
    end
  end

  # Fee Collections
  students.first(10).each do |student|
    fee_structures.each_with_index do |fs, i|
      FeeCollection.find_or_create_by!(student: student, fee_structure: fs) do |fc|
        fc.amount = fs.amount
        fc.paid_date = [Date.today, nil].sample
        fc.due_date = Date.today + 15.days
        fc.status = ["paid", "unpaid"].sample
        fc.payment_mode = "cash"
      end
    end
  end

  # Attendance
  students.first(10).each do |student|
    StudentAttendance.find_or_create_by!(student: student, date: Date.today) do |sa|
      sa.classroom = student.classroom
      sa.status = ["present", "present", "present", "absent", "leave"].sample
    end
  end

  teachers.first(3).each do |teacher|
    TeacherAttendance.find_or_create_by!(teacher: teacher, date: Date.today) do |ta|
      ta.status = ["present", "present", "present", "absent"].sample
    end
  end

  # Grade Systems
  grade_systems_data = [
    { min_marks: 91, max_marks: 100, grade: "A1", grade_point: 9.99 },
    { min_marks: 81, max_marks: 90, grade: "A2", grade_point: 9.0 },
    { min_marks: 71, max_marks: 80, grade: "B1", grade_point: 8.0 },
    { min_marks: 61, max_marks: 70, grade: "B2", grade_point: 7.0 },
    { min_marks: 51, max_marks: 60, grade: "C1", grade_point: 6.0 },
    { min_marks: 41, max_marks: 50, grade: "C2", grade_point: 5.0 },
    { min_marks: 33, max_marks: 40, grade: "D", grade_point: 4.0 },
    { min_marks: 0, max_marks: 32, grade: "E", grade_point: 0.0 },
  ]
  grade_systems_data.each do |gs|
    GradeSystem.find_or_create_by!(school: school, grade: gs[:grade]) do |g|
      g.assign_attributes(gs)
    end
  end

  # Exams
  exam = Exam.find_or_create_by!(school: school, title: "Mid Term Exam 2026") do |e|
    e.classroom = classrooms.first
    e.section = sections.first
    e.subject = subjects.first
    e.exam_type = "mid_term"
    e.exam_date = 1.week.from_now
    e.max_marks = 100
    e.pass_marks = 35
    e.status = "upcoming"
  end

  # Exam Results for first 5 students
  students.first(5).each_with_index do |student, i|
    marks = [85, 72, 45, 91, 38][i]
    ExamResult.find_or_create_by!(exam: exam, student: student) do |er|
      er.marks_obtained = marks
      er.status = "published"
    end
  end

  # Homeworks
  hw = Homework.find_or_create_by!(school: school, title: "Math Practice - Algebra") do |h|
    h.teacher = teachers.first
    h.classroom = classrooms.first
    h.section = sections.first
    h.subject = subjects.first
    h.description = "Solve all exercises from Chapter 3"
    h.due_date = 3.days.from_now
    h.status = "active"
  end

  # Homework Submissions
  students.first(3).each do |student|
    HomeworkSubmission.find_or_create_by!(homework: hw, student: student) do |sub|
      sub.submission_text = "Completed all exercises."
      sub.submitted_at = Time.current
      sub.status = "submitted"
    end
  end

  # Leave Applications (use school admin as applicant for demo)
  admin_user = school.users.school_admin.first
  LeaveApplication.find_or_create_by!(school: school, user: admin_user) do |la|
    la.applicant_type = "staff"
    la.leave_type = "sick"
    la.start_date = Date.today + 2.days
    la.end_date = Date.today + 3.days
    la.reason = "Fever and cold"
    la.status = "pending"
  end

  # Library Books
  books_data = [
    { title: "NCERT Mathematics Class 10", author: "NCERT", isbn: "978-8174506340", category: "Textbook", total_copies: 5 },
    { title: "Science Encyclopedia", author: "DK", isbn: "978-0241243692", category: "Reference", total_copies: 3 },
    { title: "Harry Potter and the Philosopher's Stone", author: "J.K. Rowling", isbn: "978-0747532699", category: "Fiction", total_copies: 4 },
  ]
  books_data.each do |b|
    LibraryBook.find_or_create_by!(school: school, isbn: b[:isbn]) do |lb|
      lb.assign_attributes(b.merge(available_copies: b[:total_copies]))
    end
  end

  # Vehicles
  vehicle = Vehicle.find_or_create_by!(school: school, registration_number: "KA-01-AB-1234") do |v|
    v.name = "School Bus 1"
    v.vehicle_type = "bus"
    v.capacity = 40
    v.status = "active"
  end

  # Drivers
  driver = Driver.find_or_create_by!(school: school, license_number: "DL-123456") do |d|
    d.name = "Ramesh Yadav"
    d.phone = "9876549999"
    d.status = "active"
  end

  # Routes
  route = Route.find_or_create_by!(school: school, name: "Route 1 - North") do |r|
    r.vehicle = vehicle
    r.driver = driver
    r.start_location = "School Gate"
    r.end_location = "North City Center"
    r.status = "active"
  end

  # Route Stops
  ["Stop 1", "Stop 2", "Stop 3"].each_with_index do |name, i|
    RouteStop.find_or_create_by!(route: route, stop_name: name) do |rs|
      rs.stop_order = i + 1
      rs.morning_arrival_time = "07:#{30 + i * 10}"
    end
  end

  # Hostel Rooms
  hostel_room = HostelRoom.find_or_create_by!(school: school, room_number: "101") do |hr|
    hr.floor = "1"
    hr.room_type = "standard"
    hr.capacity = 2
    hr.status = "available"
  end

  # Hostel Beds
  2.times do |i|
    HostelBed.find_or_create_by!(hostel_room: hostel_room, bed_number: "B#{i + 1}") do |hb|
      hb.status = "vacant"
    end
  end

  # Inventory Items
  inventory_data = [
    { name: "Dell Laptop", category: "Computers", quantity: 10 },
    { name: "Epson Projector", category: "Projectors", quantity: 3 },
    { name: "Student Desk", category: "Furniture", quantity: 50 },
  ]
  inventory_data.each do |item|
    InventoryItem.find_or_create_by!(school: school, name: item[:name]) do |ii|
      ii.assign_attributes(item)
    end
  end

  # Announcements
  Announcement.find_or_create_by!(school: school, title: "Welcome Back!") do |a|
    a.content = "Welcome to the new academic year 2026!"
    a.audience_type = "everyone"
    a.priority = "normal"
    a.published_at = Time.current
    a.created_by = school.users.school_admin.first || User.first
  end

  # Live Classes
  LiveClass.find_or_create_by!(school: school, title: "Math Live Class - Algebra") do |lc|
    lc.classroom = classrooms.first
    lc.section = sections.first
    lc.subject = subjects.first
    lc.teacher = teachers.first
    lc.platform = "zoom"
    lc.meeting_url = "https://zoom.us/j/123456789"
    lc.scheduled_at = 2.days.from_now
    lc.duration_minutes = 60
    lc.status = "scheduled"
  end

  # Courses (LMS)
  course = Course.find_or_create_by!(school: school, title: "Mathematics - Class 1") do |c|
    c.classroom = classrooms.first
    c.subject = subjects.first
    c.teacher = teachers.first
    c.description = "Complete mathematics course for class 1"
    c.status = "active"
  end

  # Chapters
  chapter = Chapter.find_or_create_by!(course: course, title: "Numbers") do |ch|
    ch.order_position = 1
    ch.description = "Introduction to numbers"
  end

  # Topics
  topic = Topic.find_or_create_by!(chapter: chapter, title: "Counting 1-100") do |t|
    t.order_position = 1
    t.content = "Learn to count from 1 to 100"
  end

  # Quizzes
  quiz = Quiz.find_or_create_by!(topic: topic, title: "Numbers Quiz") do |q|
    q.time_limit_minutes = 15
    q.total_marks = 5
  end

  # Quiz Questions
  QuizQuestion.find_or_create_by!(quiz: quiz, question_text: "What comes after 5?") do |qq|
    qq.question_type = "mcq"
    qq.options = ["4", "6", "7", "8"]
    qq.correct_answer = "6"
    qq.marks = 1
  end

  # Student Users
  students.first(3).each do |student|
    User.find_or_create_by!(email: "student.#{student.id}@example.com") do |u|
      u.name = student.name
      u.password = "password"
      u.password_confirmation = "password"
      u.role = "student"
      u.school = school
      u.student = student
      u.status = "active"
    end
  end
end

puts "✅ Seeds loaded successfully!"
puts ""
puts "Login credentials:"
puts "  Super Admin: admin@campus.one / password"
puts "  School Admin (Active sub): greenwood.admin@example.com / password"
puts "  School Admin (No sub): sunrise.admin@example.com / password  ← Will see subscription page"
puts "  Teacher: teacher1@example.com / password  (Greenwood teacher)"
puts "  Student: student.1@example.com / password  (Greenwood student)"

