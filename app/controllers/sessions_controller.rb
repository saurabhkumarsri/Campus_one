class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    redirect_to after_login_path(current_user) if current_user
  end

  def create
    user = User.find_by(email: params[:email].to_s.downcase)
    if user&.authenticate(params[:password])
      if user.active?
        session[:user_id] = user.id
        redirect_to after_login_path(user), notice: "Welcome back, #{user.name}!"
      else
        flash.now[:alert] = "Your account is inactive."
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Invalid email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "You have been logged out."
  end

  private

  def after_login_path(user)
    if user.super_admin?
      super_admin_root_path
    elsif user.school_admin?
      if user.school&.subscription_expired?
        school_admin_subscriptions_path
      else
        school_admin_root_path
      end
    elsif user.teacher?
      school_admin_teacher_dashboard_path
    elsif user.student?
      student_portal_root_path
    else
      root_path
    end
  end
end
