class Profile < ApplicationRecord
  belongs_to :user

  # Store preferences as JSON
  serialize :preferences, coder: JSON

  # Avatar upload (we'll use Active Storage later)
  attribute :avatar_data, :text

  # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone_number, presence: true, format: { with: /\A\+?[\d\s\-\(\)]+\z/ }
  validates :date_of_birth, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end
end
