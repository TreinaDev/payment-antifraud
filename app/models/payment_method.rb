class PaymentMethod < ApplicationRecord
  enum status: { pending: 0 }
end
