module SchoolAdmin
  class TeacherDocumentsController < BaseController
    def index
      teacher = current_user.teacher
      if teacher
        @documents = scope_query(TeacherDocument).where(teacher_id: teacher.id)
      else
        @documents = scope_query(TeacherDocument).includes(:teacher)
      end
    end

    def new
      @document = scope_query(TeacherDocument).new
    end

    def create
      @document = scope_query(TeacherDocument).new(document_params)
      if @document.save
        redirect_to school_admin_teacher_documents_path, notice: "Document uploaded."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      @document = scope_query(TeacherDocument).find(params[:id])
      @document.destroy
      redirect_to school_admin_teacher_documents_path, notice: "Document deleted."
    end

    private

    def document_params
      params.require(:teacher_document).permit(:teacher_id, :doc_type, :title, :description, :file)
    end
  end
end
