class RentalApplicationPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    record.tenant == user || record.property.landlord == user
  end

  def create?
    user.tenant? && record.tenant == user
  end

  def update?
    record.property.landlord == user
  end

  def destroy?
    record.tenant == user
  end
end
