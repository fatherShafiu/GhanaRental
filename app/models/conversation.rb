class Conversation < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :recipient, class_name: "User"
  belongs_to :property, optional: true
  has_many :messages, dependent: :destroy

  validates :sender_id, uniqueness: { scope: [ :recipient_id, :property_id ] }

  scope :between, ->(sender_id, recipient_id, property_id = nil) {
    where(sender_id: sender_id, recipient_id: recipient_id, property_id: property_id)
      .or(where(sender_id: recipient_id, recipient_id: sender_id, property_id: property_id))
  }

  def other_participant(user)
    user == sender ? recipient : sender
  end

  def unread_messages_count(user)
    messages.where.not(user: user).where(read: false).count
  end

  def mark_as_read(user)
    messages.where.not(user: user).update_all(read: true)
  end
end
