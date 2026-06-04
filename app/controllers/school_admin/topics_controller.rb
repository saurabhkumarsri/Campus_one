module SchoolAdmin
  class TopicsController < BaseController
    include SchoolScope

    def create
      @course = scope_query(Course).find(params[:course_id])
      @chapter = @course.chapters.find(params[:chapter_id])
      @topic = @chapter.topics.new(topic_params)
      if @topic.save
        redirect_to school_admin_course_path(@course), notice: "Topic added."
      else
        redirect_to school_admin_course_path(@course), alert: "Failed to add topic."
      end
    end

    def update
      @course = scope_query(Course).find(params[:course_id])
      @chapter = @course.chapters.find(params[:chapter_id])
      @topic = @chapter.topics.find(params[:id])
      if @topic.update(topic_params)
        redirect_to school_admin_course_path(@course), notice: "Topic updated."
      else
        redirect_to school_admin_course_path(@course), alert: "Update failed."
      end
    end

    def destroy
      @course = scope_query(Course).find(params[:course_id])
      @chapter = @course.chapters.find(params[:chapter_id])
      @topic = @chapter.topics.find(params[:id])
      @topic.destroy
      redirect_to school_admin_course_path(@course), notice: "Topic removed."
    end

    private

    def topic_params
      params.require(:topic).permit(:title, :content, :video_url, :pdf_url, :order_position, :status)
    end
  end
end
