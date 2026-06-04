module SchoolAdmin
  class AnnouncementsController < BaseController
    include SchoolScope

    def index
      @announcements = scope_query(Announcement).includes(:created_by).order(created_at: :desc)
    end

    def new
      @announcement = Announcement.new
    end

    def create
      @announcement = scope_query(Announcement).new(announcement_params)
      @announcement.created_by = current_user
      @announcement.published_at = Time.current
      if @announcement.save
        redirect_to school_admin_announcements_path, notice: "Announcement published."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @announcement = scope_query(Announcement).find(params[:id])
    end

    def update
      @announcement = scope_query(Announcement).find(params[:id])
      if @announcement.update(announcement_params)
        redirect_to school_admin_announcements_path, notice: "Announcement updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @announcement = scope_query(Announcement).find(params[:id])
      @announcement.destroy
      redirect_to school_admin_announcements_path, notice: "Announcement deleted."
    end

    private

    def announcement_params
      params.require(:announcement).permit(:title, :content, :audience_type, :priority, :expires_at)
    end
  end
end
