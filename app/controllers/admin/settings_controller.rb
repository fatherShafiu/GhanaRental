module Admin
  class SettingsController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin

    def index
      # System settings page
    end

    def update
      # Handle system settings updates
      redirect_to admin_settings_path, notice: "Settings updated successfully."
    end

    private

    def require_admin
      redirect_to root_path, alert: "Access denied." unless current_user.admin?
    end
  end
end
