class PaymentMethod < ApplicationRecord
  has_one_attached :image
  enum status: { active: 0, inactive: 10 }
  has_many :invoices, dependent: :destroy

  validates :name, :tax_percentage, :tax_maximum, :payment_type, presence: true
  validates :tax_percentage, :tax_maximum, numericality: { greater_than_or_equal_to: 0 }
  validates :image, attached: true
  validates :image, content_type: ['image/png', 'image/jpeg']

  def payment_name_and_type
    "#{name} - #{payment_type}"
  end
end
