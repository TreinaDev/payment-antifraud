FactoryBot.define do
  factory :fraud_report do
    registration_number { "MyString" }
    description { "MyString" }
    status { 1 }
  end
end
