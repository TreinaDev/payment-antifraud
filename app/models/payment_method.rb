class PaymentMethod < ApplicationRecord
  has_one_attached :image
  enum status: { active: 0, inactive: 10 }
  has_many :invoices, dependent: :destroy

  validates :name, :tax_percentage, :tax_maximum, :payment_type, :max_parcels, presence: true
  validates :tax_percentage, :tax_maximum, :max_parcels, numericality: { greater_than_or_equal_to: 0 }
  validates :image, attached: true
  validates :image, content_type: ['image/png', 'image/jpeg']
end
