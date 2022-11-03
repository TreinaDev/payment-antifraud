class PaymentMethod < ApplicationRecord
  enum status: { active: 0, inactive: 10 }

  validates :name, :tax_percentage, :tax_maximum, :payment_type, presence: true
  validates :tax_percentage, :tax_maximum, numericality: { greater_than_or_equal_to: 0 }
end
