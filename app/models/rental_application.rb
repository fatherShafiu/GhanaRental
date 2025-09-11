class RentalApplication < ApplicationRecord
  belongs_to :property
  belongs_to :tenant, class_name: "User"

  enum status: { pending: 0, approved: 1, rejected: 2, withdrawn: 3 }

  validates :message, presence: true, length: { maximum: 1000 }
  validates :tenant_id, uniqueness: { scope: :property_id, message: "has already applied for this property" }

  before_create :set_submitted_at

  scope :for_property, ->(property_id) { where(property_id: property_id) }
  scope :by_tenant, ->(tenant_id) { where(tenant_id: tenant_id) }

  private

  def set_submitted_at
    self.submitted_at = Time.current
  end
end
