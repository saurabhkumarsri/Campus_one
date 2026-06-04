module SchoolAdmin
  class ChaptersController < BaseController
    include SchoolScope

    def create
      @course = scope_query(Course).find(params[:course_id])
      @chapter = @course.chapters.new(chapter_params)
      if @chapter.save
        redirect_to school_admin_course_path(@course), notice: "Chapter added."
      else
        redirect_to school_admin_course_path(@course), alert: "Failed to add chapter."
      end
    end

    def update
      @course = scope_query(Course).find(params[:course_id])
      @chapter = @course.chapters.find(params[:id])
      if @chapter.update(chapter_params)
        redirect_to school_admin_course_path(@course), notice: "Chapter updated."
      else
        redirect_to school_admin_course_path(@course), alert: "Update failed."
      end
    end

    def destroy
      @course = scope_query(Course).find(params[:course_id])
      @chapter = @course.chapters.find(params[:id])
      @chapter.destroy
      redirect_to school_admin_course_path(@course), notice: "Chapter removed."
    end

    private

    def chapter_params
      params.require(:chapter).permit(:title, :description, :order_position, :status)
    end
  end
end
