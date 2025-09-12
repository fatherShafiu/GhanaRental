class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    authorize current_user

    case current_user.role
    when "admin"
      setup_admin_dashboard
      render "admin_dashboard"
    when "landlord"
      setup_landlord_dashboard
      render "landlord_dashboard"
    when "tenant"
      setup_tenant_dashboard
      render "tenant_dashboard"
    end
  end

  private

  def setup_admin_dashboard
    @users = User.all.order(created_at: :desc).limit(10)
    @recent_properties = Property.includes(:landlord).order(created_at: :desc).limit(10)
    @recent_applications = RentalApplication.includes(:property, :tenant).order(created_at: :desc).limit(10)
    @pending_properties = Property.where(status: :draft).count
    @pending_applications = RentalApplication.pending.count

    # Monthly stats
    @monthly_users = User.where(created_at: Time.current.all_month).count
    @monthly_properties = Property.where(created_at: Time.current.all_month).count
    @monthly_revenue = Payment.completed.where(created_at: Time.current.all_month).sum(:amount)
  end

  def setup_landlord_dashboard
    @properties = current_user.properties.includes(:favorites).order(created_at: :desc)
    @published_count = @properties.published.count
    @draft_count = @properties.draft.count
    @archived_count = @properties.archived.count
    @total_favorites = @properties.joins(:favorites).count

    # Recent applications for landlord's properties
    @recent_applications = RentalApplication.joins(:property)
                                          .where(properties: { landlord_id: current_user.id })
                                          .includes(:tenant)
                                          .order(created_at: :desc)
                                          .limit(5)
  end

  def setup_tenant_dashboard
    @favorite_properties = current_user.favorited_properties.includes(:landlord).published.available
    @recent_properties = Property.published.available.order(created_at: :desc).limit(6)
    @my_applications = current_user.rental_applications.includes(:property).order(created_at: :desc).limit(5)
  end
end
