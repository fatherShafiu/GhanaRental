class DocumentPolicy < ApplicationPolicy
  def index?
    record.rental_application.tenant == user || record.rental_application.property.landlord == user
  end

  def show?
    record.rental_application.tenant == user || record.rental_application.property.landlord == user
  end

  def create?
    record.rental_application.tenant == user
  end

  def new?
    create?
  end

  def destroy?
    record.user == user || record.rental_application.property.landlord == user
  end
end
