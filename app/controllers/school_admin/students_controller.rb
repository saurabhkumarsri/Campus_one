module SchoolAdmin
  class StudentsController < BaseController
    def index
      @students = scope_query(Student).includes(:classroom, :section).order(:name)
    end

    def show
      @student = scope_query(Student).find(params[:id])
    end

    def new
      @student = Student.new
    end

    def create
      @student = scope_query(Student).new(student_params)
      if @student.save
        redirect_to school_admin_students_path, notice: "Student admitted successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @student = scope_query(Student).find(params[:id])
    end

    def update
      @student = scope_query(Student).find(params[:id])
      if @student.update(student_params)
        redirect_to school_admin_students_path, notice: "Student updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @student = scope_query(Student).find(params[:id])
      @student.destroy
      redirect_to school_admin_students_path, notice: "Student deleted successfully."
    end

    def id_card
      @student = scope_query(Student).find(params[:id])
    end

    def download_id_card
      @student = scope_query(Student).find(params[:id])
      pdf = IdCardPdf.new(@student)
      send_data pdf.render, filename: "id_card_#{@student.roll_no || @student.id}.pdf", type: "application/pdf", disposition: "inline"
    end

    private

    def student_params
      params.require(:student).permit(
        :name, :roll_no, :father_name, :mother_name, :guardian_name,
        :mobile, :email, :address, :date_of_birth, :gender,
        :admission_date, :classroom_id, :section_id, :status
      ).merge(school_id: current_user.school_id)
    end
  end
end
