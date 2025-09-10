class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    authorize current_user

    case current_user.role
    when "admin"
      @users = User.all.order(created_at: :desc).limit(10)
      @recent_properties = Property.includes(:landlord).order(created_at: :desc).limit(10)
      @pending_properties = Property.where(status: :draft).count
      render "admin_dashboard"
    when "landlord"
      @properties = current_user.properties.includes(:favorites).order(created_at: :desc)
      @published_count = @properties.published.count
      @draft_count = @properties.draft.count
      @archived_count = @properties.archived.count
      @total_favorites = @properties.joins(:favorites).count
      render "landlord_dashboard"
    when "tenant"
      @favorite_properties = current_user.favorited_properties.includes(:landlord).published.available
      @recent_properties = Property.published.available.order(created_at: :desc).limit(6)
      render "tenant_dashboard"
    end
  end
end
