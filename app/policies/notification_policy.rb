class NotificationPolicy < ApplicationPolicy
  def index?
    true
  end

  def mark_as_read?
    record.user == user
  end

  def mark_all_as_read?
    true
  end
end
