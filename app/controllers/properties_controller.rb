class PropertiesController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_property, only: [ :show, :edit, :update, :destroy, :publish, :archive, :purge_image ]
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def index
    @properties = policy_scope(Property).includes(:landlord, images_attachments: :blob)

    # Apply search
    @properties = @properties.search(params[:search]) if params[:search].present?

    # Apply filters
    @properties = apply_filters(@properties, filter_params)

    # Handle map view vs list view
    if params[:view] == "map" && @properties.any?
      @map_properties = @properties.where.not(latitude: nil, longitude: nil)
      render :map
    else
      # Sort options
      apply_sorting
      # Pagination
      @pagy, @properties = pagy(@properties, items: 12)

      respond_to do |format|
        format.html
        format.turbo_stream
      end
    end
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
  @property = current_user.properties.find(params[:id])
  if @property.update(status: :published)
    respond_to do |format|
      format.html { redirect_to my_properties_properties_path, notice: "Property published successfully!" }
      format.turbo_stream
    end
  else
    redirect_to my_properties_properties_path, alert: "Failed to publish property."
  end
end

def archive
  @property = current_user.properties.find(params[:id])
  if @property.update(status: :archived)
    respond_to do |format|
      format.html { redirect_to my_properties_properties_path, notice: "Property archived successfully!" }
      format.turbo_stream
    end
  else
    redirect_to my_properties_properties_path, alert: "Failed to archive property."
  end
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

  def purge_image
    @property = Property.find(params[:id])
    image = @property.images.find(params[:image_id])
    image.purge
    redirect_to edit_property_path(@property), notice: "Image removed successfully"
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

  def filter_params
    params.permit(
      :min_price, :max_price, :min_bedrooms, :min_bathrooms,
      :min_sqft, :available_by, :property_type, :furnished,
      :pets_allowed, :latitude, :longitude, :radius, :search
    ).to_h.symbolize_keys
  end

  def apply_sorting
    sort = params[:sort] || "newest"
    case sort
    when "price_low_high"
      @properties = @properties.order(price: :asc)
    when "price_high_low"
      @properties = @properties.order(price: :desc)
    when "newest"
      @properties = @properties.order(created_at: :desc)
    when "oldest"
      @properties = @properties.order(created_at: :asc)
    when "bedrooms"
      @properties = @properties.order(bedrooms: :desc)
    when "size"
      @properties = @properties.order(square_feet: :desc)
    end
  end

  def apply_filters(properties, filters)
    # Price range
    if filters[:min_price].present? && filters[:max_price].present?
      properties = properties.where(price: filters[:min_price].to_f..filters[:max_price].to_f)
    end

    # Bedrooms
    if filters[:min_bedrooms].present?
      properties = properties.where("bedrooms >= ?", filters[:min_bedrooms].to_i)
    end

    # Bathrooms
    if filters[:min_bathrooms].present?
      properties = properties.where("bathrooms >= ?", filters[:min_bathrooms].to_i)
    end

    # Square feet
    if filters[:min_sqft].present?
      properties = properties.where("square_feet >= ?", filters[:min_sqft].to_i)
    end

    # Availability
    if filters[:available_by].present?
      properties = properties.where("available_from <= ?", Date.parse(filters[:available_by]))
    end

    # Property type
    if filters[:property_type].present?
      properties = properties.where(property_type: filters[:property_type])
    end

    # Furnished
    if filters[:furnished].present?
      properties = properties.where(furnished: filters[:furnished] == "true")
    end

    # Pets allowed
    if filters[:pets_allowed].present?
      properties = properties.where(pets_allowed: filters[:pets_allowed] == "true")
    end

    # Location-based filtering (simplified for now)
    if filters[:latitude].present? && filters[:longitude].present?
      properties = properties.where.not(latitude: nil, longitude: nil)
    end

    properties
  end
end
