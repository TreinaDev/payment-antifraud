class FraudReport < ApplicationRecord
  enum status: { pending: 0, confirmed_fraud: 5 }
end
