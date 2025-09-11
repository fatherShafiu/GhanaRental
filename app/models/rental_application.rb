class RentalApplication < ApplicationRecord
  belongs_to :property
  belongs_to :tenant, class_name: "User"
  has_many :notifications, as: :notifiable, dependent: :destroy

  enum status: { pending: 0, approved: 1, rejected: 2, withdrawn: 3 }

  validates :message, presence: true, length: { maximum: 1000 }
  validates :tenant_id, uniqueness: { scope: :property_id, message: "has already applied for this property" }

  before_create :set_submitted_at

  scope :for_property, ->(property_id) { where(property_id: property_id) }
  scope :by_tenant, ->(tenant_id) { where(tenant_id: tenant_id) }

  after_create_commit :notify_landlord
  after_update_commit :notify_tenant_of_status_change

  has_one :payment, dependent: :destroy

  after_update :create_payment_on_approval, if: :saved_change_to_status?

  def create_payment_on_approval
    return unless approved? && payment.nil?

    create_payment(
      amount: property.price,
      currency: "GHS", # Ghana Cedis
      status: :pending
    )

    # Notify tenant to make payment
    Notification.create(
      user: tenant,
      notifiable: payment,
      message: "Your application was approved! Please make your first rent payment of $#{property.price}."
    )
  end

  private

  def set_submitted_at
    self.submitted_at = Time.current
  end



def notify_landlord
  Notification.create(
    user: property.landlord,
    notifiable: self,
    message: "New rental application from #{tenant.profile&.full_name || tenant.email} for #{property.title}"
  )
end

def notify_tenant_of_status_change
  return unless saved_change_to_status?

  Notification.create(
    user: tenant,
    notifiable: self,
    message: "Your application for #{property.title} has been #{status}."
  )
end
end
