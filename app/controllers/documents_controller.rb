class DocumentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_rental_application, only: [ :new, :create, :index ]
  before_action :set_document, only: [ :show, :destroy ]

  def index
    @documents = @rental_application.documents.includes(:user)
    authorize @documents
  end

  def show
    authorize @document
  end

  def new
    @document = @rental_application.documents.new(user: current_user)
    authorize @document
  end

  def create
    @document = @rental_application.documents.new(document_params)
    @document.user = current_user

    authorize @document

    if @document.save
      redirect_to rental_application_path(@rental_application),
                  notice: "Document uploaded successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @document
    @document.destroy
    redirect_to rental_application_path(@document.rental_application),
                notice: "Document deleted successfully!"
  end

  private

  def set_rental_application
    @rental_application = RentalApplication.find(params[:rental_application_id])
  end

  def set_document
    @document = Document.find(params[:id])
  end

  def document_params
    params.require(:document).permit(:document_type, files: [])
  end
end
