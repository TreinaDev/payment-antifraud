FactoryBot.define do
  factory :company_payment_option do
    user { nil }
    company_domain { "MyString" }
    payment_method { nil }
    max_parcels { 1 }
    single_parcel_discount { 1 }
  end
end
