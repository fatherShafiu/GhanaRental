class ConversationPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    record.sender == user || record.recipient == user
  end

  def create?
    true
  end
end
