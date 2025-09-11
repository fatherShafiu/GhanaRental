class PaymentPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    record.rental_application.tenant == user || record.rental_application.property.landlord == user
  end

  def process_payment?
    record.rental_application.tenant == user && record.pending?
  end

  def status?
    record.rental_application.tenant == user || record.rental_application.property.landlord == user
  end
end
