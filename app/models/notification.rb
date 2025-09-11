class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(read: false) }
  scope :recent, -> { order(created_at: :desc).limit(10) }

  after_create_commit :broadcast_to_user

  def mark_as_read
    update(read: true)
  end

  private


def broadcast_to_user
  broadcast_append_to user,
                     target: "notifications_#{user.id}",
                     partial: "notifications/notification",
                     locals: { notification: self }

  broadcast_update_to user,
                     target: "notifications_count",
                     partial: "notifications/count",
                     locals: { count: user.unread_notifications_count }
end
end
