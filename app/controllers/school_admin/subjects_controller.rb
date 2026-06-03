module SchoolAdmin
  class SubjectsController < BaseController
    def index
      @subjects = scope_query(Subject).order(:name)
    end

    def new
      @subject = Subject.new
    end

    def create
      @subject = scope_query(Subject).new(subject_params)
      if @subject.save
        redirect_to school_admin_subjects_path, notice: "Subject created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @subject = scope_query(Subject).find(params[:id])
    end

    def update
      @subject = scope_query(Subject).find(params[:id])
      if @subject.update(subject_params)
        redirect_to school_admin_subjects_path, notice: "Subject updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @subject = scope_query(Subject).find(params[:id])
      @subject.destroy
      redirect_to school_admin_subjects_path, notice: "Subject deleted successfully."
    end

    private

    def subject_params
      params.require(:subject).permit(:name, :code, :status).merge(school_id: current_user.school_id)
    end
  end
end
