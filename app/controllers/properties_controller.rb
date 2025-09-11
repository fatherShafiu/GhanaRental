class PropertiesController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_property, only: [ :show, :edit, :update, :destroy, :publish, :archive ]
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def index
    @properties = policy_scope(Property).includes(:landlord, images_attachments: :blob)

    # Filtering
    @properties = @properties.by_city(params[:city]) if params[:city].present?
    @properties = @properties.by_price_range(params[:min_price].to_f, params[:max_price].to_f) if params[:min_price].present? && params[:max_price].present?
    @properties = @properties.where(property_type: params[:property_type]) if params[:property_type].present?
    @properties = @properties.where(bedrooms: params[:bedrooms]) if params[:bedrooms].present?

    # Pagination
    @pagy, @properties = pagy(@properties.order(created_at: :desc), items: 12)
  end

  def show
    authorize @property
  end

  def new
    @property = current_user.properties.new
    authorize @property
  end

  def create
    @property = current_user.properties.new(property_params)
    authorize @property

    if @property.save
      redirect_to @property, notice: "Property was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @property
  end

  def update
    authorize @property
    if @property.update(property_params)
      redirect_to @property, notice: "Property was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @property
    @property.destroy
    redirect_to properties_url, notice: "Property was successfully destroyed."
  end

  def publish
    authorize @property
    @property.published!
    redirect_to @property, notice: "Property is now published."
  end

  def archive
    authorize @property
    @property.archived!
    redirect_to @property, notice: "Property has been archived."
  end

def my_properties
  @properties = current_user.properties.includes(:favorites, images_attachments: :blob).order(created_at: :desc)
  authorize @properties
end

def favorites
  @properties = current_user.favorited_properties.includes(:landlord, images_attachments: :blob).published.available
  authorize @properties
end
# In app/controllers/properties_controller.rb
def toggle_favorite
  @property = Property.find(params[:id])
  if current_user.favorited?(@property)
    current_user.favorites.where(property: @property).destroy_all
    notice = "Removed from favorites"
  else
    current_user.favorites.create(property: @property)
    notice = "Added to favorites"
  end

  redirect_to @property, notice: notice
end
  private

  def set_property
    @property = Property.find(params[:id])
  end

  def property_params
    params.require(:property).permit(
      :title, :description, :property_type, :price, :bedrooms,
      :bathrooms, :square_feet, :address, :city, :state, :zip_code,
      :available_from, :featured, images: [], floor_plan: []
    )
  end
end
