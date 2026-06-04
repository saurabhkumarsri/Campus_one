module SchoolAdmin
  class AiToolsController < BaseController
    include SchoolScope

    def report_generator
      @students = scope_query(Student).active.order(:name)
      @subjects = scope_query(Subject).order(:name)
    end

    def generate_report
      student = scope_query(Student).find(params[:student_id])
      notes = params[:teacher_notes]
      generated = AiService.generate_report(student, notes)

      @ai_content = scope_query(AiGeneratedContent).create!(
        user: current_user,
        content_type: "report",
        input_prompt: notes,
        generated_content: generated,
        metadata: { student_id: student.id }
      )

      redirect_to school_admin_ai_report_generator_path, notice: "Report generated!"
    rescue StandardError => e
      redirect_to school_admin_ai_report_generator_path, alert: "Error: #{e.message}"
    end

    def question_paper
      @subjects = scope_query(Subject).order(:name)
      @classrooms = scope_query(Classroom).order(:name)
    end

    def generate_question_paper
      generated = AiService.generate_question_paper(
        topic: params[:topic],
        subject: params[:subject_name],
        classroom: params[:classroom],
        marks: params[:total_marks],
        difficulty: params[:difficulty]
      )

      @ai_content = scope_query(AiGeneratedContent).create!(
        user: current_user,
        content_type: "question_paper",
        topic: params[:topic],
        subject_name: params[:subject_name],
        input_prompt: params.to_unsafe_h.to_json,
        generated_content: generated
      )

      redirect_to school_admin_ai_question_paper_path, notice: "Question paper generated!"
    rescue StandardError => e
      redirect_to school_admin_ai_question_paper_path, alert: "Error: #{e.message}"
    end

    def homework_generator
      @subjects = scope_query(Subject).order(:name)
      @classrooms = scope_query(Classroom).order(:name)
    end

    def generate_homework
      generated = AiService.generate_homework(
        classroom: params[:classroom],
        subject: params[:subject_name],
        topic: params[:topic]
      )

      @ai_content = scope_query(AiGeneratedContent).create!(
        user: current_user,
        content_type: "homework",
        topic: params[:topic],
        subject_name: params[:subject_name],
        input_prompt: params.to_unsafe_h.to_json,
        generated_content: generated
      )

      redirect_to school_admin_ai_homework_generator_path, notice: "Homework generated!"
    rescue StandardError => e
      redirect_to school_admin_ai_homework_generator_path, alert: "Error: #{e.message}"
    end
  end
end
