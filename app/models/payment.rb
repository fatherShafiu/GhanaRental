class Payment < ApplicationRecord
  belongs_to :rental_application
  has_many :notifications, as: :notifiable, dependent: :destroy

  enum status: { pending: 0, completed: 1, failed: 2, refunded: 3 }

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :currency, presence: true
  validates :transaction_id, presence: true, uniqueness: true

  before_validation :generate_transaction_id, on: :create

  scope :for_property, ->(property_id) { joins(rental_application: :property).where(properties: { id: property_id }) }
  scope :recent, -> { order(created_at: :desc) }

  def process_payment(phone_number)
    momo_service = MomoService.new
    response = momo_service.request_to_pay(
      transaction_id,
      amount,
      currency,
      phone_number,
      "Rent payment for #{rental_application.property.title}"
    )

    update(momo_response: response.to_json)
    pending!
  end

  def check_status
    momo_service = MomoService.new
    response = momo_service.get_transaction_status(transaction_id)
    update(momo_response: response.to_json, status: map_momo_status(response["status"]))
  end

  private

  def send_receipt
  return unless completed?

  NotificationMailer.payment_receipt_email(self).deliver_later
  end

  def generate_transaction_id
    self.transaction_id ||= "PAY#{SecureRandom.hex(10).upcase}"
  end

  def map_momo_status(momo_status)
    case momo_status
    when "SUCCESSFUL"
      :completed
    when "FAILED"
      :failed
    else
      :pending
    end
  end
end
