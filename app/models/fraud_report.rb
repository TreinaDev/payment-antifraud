class FraudReport < ApplicationRecord
    enum status: {0 : pending }
end
