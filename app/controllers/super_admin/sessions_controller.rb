module SuperAdmin
  class SessionsController < ApplicationController
    skip_before_action :require_login, only: [:new, :create]

    def new
      redirect_to super_admin_root_path if current_user&.super_admin?
    end

    def create
      user = User.find_by(email: params[:email].to_s.downcase)
      if user&.super_admin? && user&.authenticate(params[:password])
        if user.active?
          session[:user_id] = user.id
          redirect_to super_admin_root_path, notice: "Welcome back, #{user.name}!"
        else
          flash.now[:alert] = "Your account is inactive."
          render :new, status: :unprocessable_entity
        end
      else
        flash.now[:alert] = "Invalid super admin credentials."
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      session[:user_id] = nil
      redirect_to super_admin_login_path, notice: "You have been logged out."
    end
  end
end
