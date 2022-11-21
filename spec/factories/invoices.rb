FactoryBot.define do
  factory :invoice do
    order_id { Faker::Number.number(digits: 2) }
    insurance_company_id { Faker::Number.number(digits: 2) }
    package_id { Faker::Number.number(digits: 2) }
    registration_number { Faker::Number.number(digits: 8) }
    status { 0 }
    payment_method_id { 1 }
    parcels { 10 }
    voucher { 'CAMPUS20' }
    total_price { Faker::Number.number(digits: 2) }
  end
end
