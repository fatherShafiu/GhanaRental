class UserPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def show?
    admin? || user == record
  end

  def create?
    admin?
  end

  def update?
    admin? || user == record
  end

  def destroy?
    admin?
  end
end
