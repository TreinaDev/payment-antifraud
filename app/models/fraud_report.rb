class FraudReport < ApplicationRecord
  enum status: { pending: 0 }
end
