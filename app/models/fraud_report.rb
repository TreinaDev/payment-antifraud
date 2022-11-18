class FraudReport < ApplicationRecord
  enum status: { pending: 0, denied: 3, confirmed_fraud: 5 }
  has_many_attached :images
  validates :registration_number, presence: true
  validates :registration_number, length: { is: 11 }
end
