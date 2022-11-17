class FraudReport < ApplicationRecord
  enum status: { pending: 0, denied: 3, confirmed_fraud: 5 }
end
