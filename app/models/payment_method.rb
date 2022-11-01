class PaymentMethod < ApplicationRecord
    enum status: {0 : pending }
end
