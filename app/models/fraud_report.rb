class FraudReport < ApplicationRecord
  enum status: { pending: 0, denied: 3, confirmed_fraud: 5 }
  has_many_attached :images
  validates :registration_number, :description,  presence: true
  validates :registration_number, length: { is: 11 }
  validates :images, attached: true
  validates :images, content_type: ['image/png', 'image/jpeg']
  validate :images_length

  private 

  def images_length
    if !images.attached? || images.length < 2
      errors.add(:base, 'São necessárias, no mínimo, duas imagens para comprovação.')
    end
  end
end
