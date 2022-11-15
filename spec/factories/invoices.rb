FactoryBot.define do
  factory :invoice do
    insurance_company_id { Faker::Number.number(digits: 2) }
    package_id { Faker::Number.number(digits: 2) }
    registration_number { Faker::Number.number(digits: 8) }
    status { 0 }
    payment_method_id { 1 }
  end
end
