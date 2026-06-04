module SchoolAdmin
  class LiveClassesController < BaseController
    include SchoolScope

    def index
      @live_classes = scope_query(LiveClass).includes(:classroom, :section, :subject, :teacher).order(:scheduled_at)
      @live_classes = @live_classes.where(status: params[:status]) if params[:status].present?
    end

    def show
      @live_class = scope_query(LiveClass).find(params[:id])
      @attendances = @live_class.live_class_attendances.includes(:student).order(:created_at)
    end

    def new
      @live_class = LiveClass.new
      load_form_data
    end

    def create
      @live_class = scope_query(LiveClass).new(live_class_params)
      if @live_class.save
        redirect_to school_admin_live_classes_path, notice: "Live class scheduled."
      else
        load_form_data
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @live_class = scope_query(LiveClass).find(params[:id])
      load_form_data
    end

    def update
      @live_class = scope_query(LiveClass).find(params[:id])
      if @live_class.update(live_class_params)
        redirect_to school_admin_live_class_path(@live_class), notice: "Live class updated."
      else
        load_form_data
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @live_class = scope_query(LiveClass).find(params[:id])
      @live_class.destroy
      redirect_to school_admin_live_classes_path, notice: "Live class cancelled."
    end

    def attendance
      @live_class = scope_query(LiveClass).find(params[:id])
      @students = @live_class.section.present? ? @live_class.section.students : @live_class.classroom.students
      @attendances = @live_class.live_class_attendances.index_by(&:student_id)
    end

    def mark_attendance
      @live_class = scope_query(LiveClass).find(params[:id])
      params[:attendance]&.each do |student_id, status|
        att = @live_class.live_class_attendances.find_or_initialize_by(student_id: student_id)
        att.update!(status: status, joined_at: Time.current) if status == "present"
        att.update!(status: status) if status != "present"
      end
      redirect_to school_admin_live_class_path(@live_class), notice: "Attendance marked."
    end

    private

    def live_class_params
      params.require(:live_class).permit(:classroom_id, :section_id, :subject_id, :teacher_id, :title, :platform, :meeting_url, :meeting_id, :passcode, :scheduled_at, :duration_minutes, :recording_url, :status)
    end

    def load_form_data
      @classrooms = scope_query(Classroom).order(:name)
      @sections = scope_query(Section).order(:name)
      @subjects = scope_query(Subject).order(:name)
      @teachers = scope_query(Teacher).active.order(:name)
    end
  end
end
