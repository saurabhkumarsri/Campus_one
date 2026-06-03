module SuperAdmin
  class SchoolAdminsController < BaseController
    def index
      @admins = User.school_admin.includes(:school).order(created_at: :desc)
    end

    def new
      @admin = User.new(role: "school_admin")
    end

    def create
      @admin = User.new(admin_params.merge(role: "school_admin"))
      if @admin.save
        redirect_to super_admin_school_admins_path, notice: "School admin created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @admin = User.find(params[:id])
    end

    def update
      @admin = User.find(params[:id])
      if @admin.update(admin_params)
        redirect_to super_admin_school_admins_path, notice: "School admin updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @admin = User.find(params[:id])
      @admin.destroy
      redirect_to super_admin_school_admins_path, notice: "School admin deleted successfully."
    end

    private

    def admin_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :school_id, :status)
    end
  end
end
