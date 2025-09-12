class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user
  has_many :notifications, as: :notifiable, dependent: :destroy
  validates :body, presence: true, length: { maximum: 2000 }

  after_create_commit :broadcast_message
  after_create_commit :notify_recipient

  def broadcast_message
    broadcast_append_to conversation,
                       target: "messages_#{conversation.id}",
                       partial: "messages/message",
                       locals: { message: self }
  end

  private

def notify_recipient
  # Create notification
  recipient = conversation.other_participant(user)
  Notification.create(
    user: recipient,
    notifiable: self,
    message: "New message from #{user.profile&.full_name || user.email}"
  )

  # Send email
  NotificationMailer.new_message_email(self).deliver_later
  # Broadcast notification count update
  broadcast_update_to recipient,
                     target: "notifications_count",
                     partial: "notifications/count",
                     locals: { count: recipient.unread_notifications_count }
end
end
