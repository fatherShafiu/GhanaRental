class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable

  # Roles
  enum role: { tenant: 0, landlord: 1, admin: 2 }

  # Associations
  has_one :profile, dependent: :destroy
  has_many :properties, foreign_key: "landlord_id", dependent: :destroy
  has_many :applications, foreign_key: "tenant_id", dependent: :destroy

  # Callbacks
  after_create :create_profile

  private

  def create_profile
    Profile.create(user: self)
  end
end
