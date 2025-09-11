class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_payment, only: [ :show, :process_payment, :status ]

  def index
    if current_user.landlord?
      @payments = Payment.joins(rental_application: :property)
                        .where(properties: { landlord_id: current_user.id })
                        .includes(rental_application: [ :property, :tenant ])
                        .recent
    else
      @payments = current_user.rental_applications_payments
                             .includes(rental_application: :property)
                             .recent
    end

    authorize @payments
  end

  def show
    authorize @payment
  end

  def process_payment
    authorize @payment

    if @payment.process_payment(params[:phone_number])
      redirect_to @payment, notice: "Payment processing started. We will notify you when completed."
    else
      redirect_to @payment, alert: "Failed to process payment. Please try again."
    end
  end

  def status
    authorize @payment
    @payment.check_status
    redirect_to @payment, notice: "Payment status updated."
  end

  def callback
    # Handle Momo callback
    transaction_id = params[:externalId]
    status = params[:status]

    payment = Payment.find_by(transaction_id: transaction_id)
    if payment
      payment.update(status: payment.map_momo_status(status))
      head :ok
    else
      head :not_found
    end
  end

  private

  def set_payment
    @payment = Payment.find(params[:id])
  end

  def payment_params
    params.require(:payment).permit(:phone_number)
  end
end
