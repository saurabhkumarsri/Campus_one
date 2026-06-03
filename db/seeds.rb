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
    fee_structures.each do |fs|
      receipt_counter += 1
      FeeCollection.create!(
        student: student,
        fee_structure: fs,
        amount: fs.amount,
        paid_date: [Date.today, nil].sample,
        due_date: Date.today + 15.days,
        status: ["paid", "unpaid"].sample,
        payment_mode: "cash",
        receipt_no: "RCP-#{school.id}-#{receipt_counter}"
      )
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
end

puts "✅ Seeds loaded successfully!"
puts ""
puts "Login credentials:"
puts "  Super Admin: admin@campus.one / password"
puts "  School Admin (Active sub): greenwood.admin@example.com / password"
puts "  School Admin (No sub): sunrise.admin@example.com / password  ← Will see subscription page"
