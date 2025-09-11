class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable

  # Roles
  enum :role, { tenant: 0, landlord: 1, admin: 2 }

  # Associations
  has_one :profile, dependent: :destroy
  has_many :properties, foreign_key: "landlord_id", dependent: :destroy
  has_many :applications, foreign_key: "tenant_id", dependent: :destroy

    has_many :favorites, dependent: :destroy
  has_many :favorited_properties, through: :favorites, source: :property

    has_many :conversations_as_sender, class_name: "Conversation", foreign_key: "sender_id", dependent: :destroy
  has_many :conversations_as_recipient, class_name: "Conversation", foreign_key: "recipient_id", dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :notifications, dependent: :destroy

  def favorited?(property)
    favorites.exists?(property: property)
  end

  # Callbacks
  after_create :create_profile


  def conversations
    Conversation.where(sender: self).or(Conversation.where(recipient: self))
  end

  def unread_notifications_count
    notifications.unread.count
  end

  private

  def create_profile
    Profile.create(user: self)
  end
end
