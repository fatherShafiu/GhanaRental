class Property < ApplicationRecord
  belongs_to :landlord, class_name: "User", foreign_key: "landlord_id"
  has_many_attached :images
  has_one_attached :floor_plan

  has_many :favorites, dependent: :destroy
  has_many :favorited_by_users, through: :favorites, source: :user

  # Enums
  enum :property_type, {
    apartment: 0, house: 1, condo: 2, townhouse: 3,
    studio: 4, loft: 5, duplex: 6, other: 7
  }

  enum :status, { draft: 0, published: 1, archived: 2, rented: 3 }

  # Validations
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 2000 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :bedrooms, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :bathrooms, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :square_feet, numericality: { greater_than: 0, only_integer: true }, allow_nil: true
  validates :address, :city, :state, presence: true
  validates :zip_code, presence: true, format: { with: /\A\d{5}(-\d{4})?\z/ }
  validates :available_from, presence: true
  validate :available_from_cannot_be_in_past, on: :create

  # Image validations
  # validate :validate_images
  validate :validate_floor_plan, if: -> { floor_plan.attached? }

  # Scopes
  scope :published, -> { where(status: :published) }
  scope :available, -> { published.where("available_from <= ?", Date.current) }
  scope :featured, -> { published.where(featured: true) }
  scope :recent, -> { order(created_at: :desc) }
  scope :by_city, ->(city) { where("LOWER(city) LIKE ?", "%#{city.downcase}%") }
  scope :by_price_range, ->(min, max) { where(price: min..max) }

  # Geocoding - Commented out for now, will implement later
  # geocoded_by :full_address
  # after_validation :geocode, if: ->(obj){ obj.address_changed? || obj.city_changed? || obj.state_changed? }

  def full_address
    [ address, city, state, zip_code ].compact.join(", ")
  end

  def main_image
    images.first if images.attached?
  end

  private

  def available_from_cannot_be_in_past
    if available_from.present? && available_from < Date.today
      errors.add(:available_from, "can't be in the past")
    end
  end

  def validate_images
    if images.attached?
      images.each do |image|
        if image.blob.byte_size > 5.megabytes
          errors.add(:images, "size should be less than 5MB")
        end

        acceptable_types = [ "image/jpeg", "image/png", "image/jpg", "image/webp" ]
        unless acceptable_types.include?(image.content_type)
          errors.add(:images, "must be a JPEG, PNG, or WebP image")
        end
      end
    else
      errors.add(:images, "must be attached")
    end
  end

  def validate_floor_plan
    if floor_plan.attached?
      if floor_plan.blob.byte_size > 2.megabytes
        errors.add(:floor_plan, "size should be less than 2MB")
      end

      acceptable_types = [ "image/jpeg", "image/png", "image/jpg", "image/webp", "application/pdf" ]
      unless acceptable_types.include?(floor_plan.content_type)
        errors.add(:floor_plan, "must be a JPEG, PNG, WebP image or PDF")
      end
    end
  end
end
