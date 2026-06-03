module SchoolAdmin
  class SectionsController < BaseController
    def index
      @sections = scope_query(Section).includes(:classroom).order("classrooms.name, sections.name")
    end

    def new
      @section = Section.new
    end

    def create
      @section = scope_query(Section).new(section_params)
      if @section.save
        redirect_to school_admin_sections_path, notice: "Section created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @section = scope_query(Section).find(params[:id])
    end

    def update
      @section = scope_query(Section).find(params[:id])
      if @section.update(section_params)
        redirect_to school_admin_sections_path, notice: "Section updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @section = scope_query(Section).find(params[:id])
      @section.destroy
      redirect_to school_admin_sections_path, notice: "Section deleted successfully."
    end

    private

    def section_params
      params.require(:section).permit(:name, :classroom_id, :status).merge(school_id: current_user.school_id)
    end
  end
end
