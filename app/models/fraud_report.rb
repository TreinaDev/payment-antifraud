class FraudReport < ApplicationRecord
  enum status: { pending: 0, denied: 3, confirmed_fraud: 5 }
  has_many_attached :images
end
