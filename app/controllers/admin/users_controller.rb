module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin

    def index
      @users = User.all.includes(:profile).order(created_at: :desc)
      @pagy, @users = pagy(@users, items: 20)
    end

    def show
      @user = User.find(params[:id])
      @properties = @user.properties.order(created_at: :desc)
      @applications = @user.rental_applications.includes(:property).order(created_at: :desc)
    end

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
        redirect_to admin_user_path(@user), notice: "User updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def require_admin
      redirect_to root_path, alert: "Access denied." unless current_user.admin?
    end

    def user_params
      params.require(:user).permit(:email, :role, :confirmed_at)
    end
  end
end
