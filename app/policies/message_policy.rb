class MessagePolicy < ApplicationPolicy
  def create?
    record.conversation.sender == user || record.conversation.recipient == user
  end
end
