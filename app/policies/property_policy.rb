class PropertyPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user&.admin?
        scope.all
      elsif user&.landlord?
        scope.where(landlord: user)
      else
        scope.published.available
      end
    end
  end

  def index?
    true
  end

  def show?
    admin? || record.published? || (landlord? && record.landlord == user)
  end

  def create?
    landlord? || admin?
  end

  def new?
    create?
  end

  def update?
    admin? || (landlord? && record.landlord == user)
  end

  def edit?
    update?
  end

  def destroy?
    admin? || (landlord? && record.landlord == user)
  end

  def publish?
    update?
  end

  def archive?
    update?
  end

  def my_properties?
    user.landlord? || user.admin?
  end
end
