class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    authorize current_user

    # Render different views based on user role
    case current_user.role
    when "admin"
      render "admin_dashboard"
    when "landlord"
      render "landlord_dashboard"
    when "tenant"
      render "tenant_dashboard"
    end
  end
end
