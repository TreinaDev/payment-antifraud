class FraudReport < ApplicationRecord
  enum status: { pending: 0, denied: 3, confirmed_fraud: 5 }
  belongs_to :insurance_company
  has_many_attached :images
  validates :registration_number, :description, presence: true
  validates :registration_number, length: { is: 11 }, numericality: { only_integer: true }
  validates :images, attached: true
  validates :images, content_type: ['image/png', 'image/jpeg']
  before_validation :ensure_images_length

  private

  def ensure_images_length
    return unless !images.attached? || images.length < 2

    errors.add(:base, 'São necessárias, no mínimo, duas imagens para comprovação.')
  end
end
