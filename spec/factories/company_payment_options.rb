FactoryBot.define do
  factory :company_payment_option do
    max_parcels { 1 }
    single_parcel_discount { 1 }
  end
end
