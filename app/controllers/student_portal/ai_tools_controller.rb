module StudentPortal
  class AiToolsController < BaseController
    def chatbot
      @history = scope_query(AiGeneratedContent)
        .where(user_id: current_user.id, content_type: "chatbot_response")
        .recent
        .limit(20)
    end

    def ask
      question = params[:question]
      context = build_student_context
      answer = AiService.answer_student_question(question, context)

      scope_query(AiGeneratedContent).create!(
        user: current_user,
        content_type: "chatbot_response",
        input_prompt: question,
        generated_content: answer
      )

      redirect_to student_portal_ai_chatbot_path, notice: "Answer: #{answer.truncate(100)}"
    rescue StandardError => e
      redirect_to student_portal_ai_chatbot_path, alert: "Error: #{e.message}"
    end

    private

    def build_student_context
      student = current_user.student
      {
        name: student.name,
        class: student.classroom&.name,
        section: student.section&.name,
        roll_no: student.roll_no,
        attendance_today: student.student_attendances.find_by(date: Date.today)&.status || "N/A"
      }
    end
  end
end
