class AiService
  # This service provides AI-generated content.
  # In a real production app, integrate with OpenAI, Claude, or similar API.
  # For demo purposes, it returns realistic mock responses.

  def self.generate_report(student, teacher_notes)
    <<~REPORT
      **Student Progress Report - #{student.name}**

      **Class:** #{student.classroom&.name || "N/A"} | **Roll No:** #{student.roll_no || "N/A"}

      **Teacher Observations:**
      #{teacher_notes || "No specific notes provided."}

      **AI Assessment:**
      Based on the teacher's feedback, #{student.name} is showing a pattern that requires attention. The noted areas suggest opportunities for targeted improvement. A personalized study plan focusing on the identified weak areas would be beneficial. Regular practice and parental involvement are recommended.

      **Action Plan:**
      1. Extra tutoring sessions 2x/week
      2. Daily practice worksheets
      3. Weekly progress check-ins
      4. Parent-teacher meeting recommended

      **Overall Remarks:** #{student.name} has potential and with focused effort can achieve significant improvement within the next term.
    REPORT
  end

  def self.generate_question_paper(topic:, subject:, classroom:, marks:, difficulty: "mixed")
    mcqs = [
      "What is the primary concept of #{topic}?\nA) Option 1\nB) Option 2\nC) Option 3\nD) Option 4",
      "Which formula is used in #{topic}?\nA) Formula A\nB) Formula B\nC) Formula C\nD) Formula D",
      "Identify the correct statement about #{topic}.\nA) Statement 1\nB) Statement 2\nC) Statement 3\nD) Statement 4"
    ]

    short = [
      "Explain the basic principles of #{topic} in 50 words.",
      "Define the key terms related to #{topic}.",
      "Draw a diagram illustrating #{topic} and label its parts."
    ]

    long = [
      "Describe #{topic} in detail with examples. (#{marks/2} Marks)",
      "Compare and contrast different aspects of #{topic}. How does it apply to real-world scenarios? (#{marks/2} Marks)",
      "Solve the following problem based on #{topic} with step-by-step explanation. (#{marks/2} Marks)"
    ]

    <<~PAPER
      **Question Paper - #{subject} (#{classroom})**
      **Topic:** #{topic} | **Total Marks:** #{marks} | **Difficulty:** #{difficulty.humanize}

      **Section A - Multiple Choice Questions (1x3 = 3 Marks)**
      #{mcqs.join("\n\n")}

      **Section B - Short Answer Questions (2x3 = 6 Marks)**
      #{short.join("\n\n")}

      **Section C - Long Answer Questions (#{marks/2}x1 = #{marks/2} Marks)**
      #{long.join("\n\n")}

      **Best of Luck!**
    PAPER
  end

  def self.generate_homework(classroom:, subject:, topic:)
    <<~HOMEWORK
      **Homework - #{subject} (#{classroom})**
      **Topic:** #{topic}

      **Instructions:** Complete all questions in your notebook. Show all working steps.

      **Q1.** Define #{topic} and list its key components. (2 Marks)

      **Q2.** Solve: [Problem related to #{topic}] (3 Marks)

      **Q3.** Explain with a diagram: How does #{topic} work in real life? (3 Marks)

      **Q4.** Research and write 5 interesting facts about #{topic}. (2 Marks)

      **Due Date:** Next class
      **Total Marks:** 10
    HOMEWORK
  end

  def self.answer_parent_question(question, context)
    # Simple keyword-based responses for demo
    q = question.downcase
    children_info = context[:children].map { |c| "#{c[:name]} (Class #{c[:class]}, Fees Due: ₹#{c[:fees_due]}, Today's Attendance: #{c[:attendance_today]})" }.join("; ")

    if q.include?("fee") || q.include?("payment") || q.include?("due")
      total = context[:children].sum { |c| c[:fees_due] }
      if total > 0
        "Total fees due for your children: ₹#{total}. Please visit the Fee Payment section to pay online via Razorpay. #{children_info}"
      else
        "All fees are up to date for your children. #{children_info}"
      end
    elsif q.include?("attendance")
      context[:children].map do |c|
        "#{c[:name]}: Today's attendance is #{c[:attendance_today]}."
      end.join(" ")
    elsif q.include?("result") || q.include?("exam") || q.include?("marks")
      "Exam results are available in the Child Progress section. You can view detailed marks and report cards there."
    elsif q.include?("homework") || q.include?("assignment")
      "Please check the Learning Portal for current homework and assignments. Due dates are updated regularly."
    elsif q.include?("teacher") || q.include?("contact")
      "You can message teachers directly using the Internal Chat feature. Go to Messages > Inbox."
    elsif q.include?("transport") || q.include?("bus")
      "Transport details are available in the school office. Please contact the admin for route information."
    else
      "Thank you for your question. For '#{question}', here is what I found:\n#{children_info}\n\nIf you need more details, please contact the school admin or use the chat feature."
    end
  end

  def self.answer_student_question(question, context)
    q = question.downcase
    student_info = "#{context[:name]} (Class #{context[:class]} #{context[:section]}, Roll No: #{context[:roll_no]}, Today's Attendance: #{context[:attendance_today]})"

    if q.include?("homework") || q.include?("assignment")
      "Please check the Homework section for your current assignments. Due dates are updated regularly. #{student_info}"
    elsif q.include?("exam") || q.include?("test") || q.include?("marks")
      "Exam schedules and results are available in the Exams section. You can also download your report card there. #{student_info}"
    elsif q.include?("attendance")
      "Your attendance today is: #{context[:attendance_today]}. Check the Attendance section for full details. #{student_info}"
    elsif q.include?("fee") || q.include?("payment") || q.include?("due")
      "Fee details are available in the Fees section. Please contact your parents or the school office for payments. #{student_info}"
    elsif q.include?("course") || q.include?("chapter") || q.include?("topic")
      "You can explore all courses, chapters, and topics in the Courses section. Quiz yourself after each topic! #{student_info}"
    elsif q.include?("teacher") || q.include?("contact")
      "You can message your teachers directly using the Messages > Inbox feature."
    else
      "Thank you for your question. For '#{question}', here is what I found:\n#{student_info}\n\nIf you need more help, ask your teacher or use the Messages feature."
    end
  end
end
