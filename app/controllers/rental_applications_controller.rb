class RentalApplicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_property, only: [ :new, :create ]
  before_action :set_application, only: [ :show, :update, :destroy ]

  def index
    if current_user.landlord?
      @applications = RentalApplication.joins(:property)
                                      .where(properties: { landlord_id: current_user.id })
                                      .includes(:property, :tenant)
                                      .order(created_at: :desc)
    else
      @applications = current_user.rental_applications.includes(:property).order(created_at: :desc)
    end

    authorize @applications
  end

  def show
    authorize @application
  end

  def new
    @application = RentalApplication.new(property: @property, tenant: current_user)
    authorize @application
  end

  def create
    @application = RentalApplication.new(application_params)
    @application.tenant = current_user
    @application.property = @property

    authorize @application

    if @application.save
      redirect_to @application, notice: "Application submitted successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @application

    if @application.update(application_params)
      redirect_to @application, notice: "Application updated successfully!"
    else
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @application
    @application.withdrawn!
    redirect_to rental_applications_path, notice: "Application withdrawn successfully!"
  end

  private

  def set_property
    @property = Property.find(params[:property_id])
  end

  def set_application
    @application = RentalApplication.find(params[:id])
  end

  def application_params
    params.require(:rental_application).permit(:message, :status)
  end
end
