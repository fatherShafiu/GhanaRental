class Document < ApplicationRecord
  belongs_to :rental_application, optional: true
  belongs_to :user
  has_many_attached :files

  enum document_type: {
    id_proof: 0,
    proof_of_income: 1,
    employment_verification: 2,
    rental_history: 3,
    credit_report: 4,
    reference_letter: 5,
    other: 6
  }

  validates :document_type, presence: true
  validate :validate_files

  def validate_files
    if files.attached?
      files.each do |file|
        if file.blob.byte_size > 5.megabytes
          errors.add(:files, "size should be less than 5MB")
        end

        acceptable_types = [ "application/pdf", "image/jpeg", "image/png", "image/jpg" ]
        unless acceptable_types.include?(file.content_type)
          errors.add(:files, "must be PDF, JPEG, or PNG")
        end
      end
    else
      errors.add(:files, "must be attached")
    end
  end

  def display_name
    document_type.humanize
  end
end
