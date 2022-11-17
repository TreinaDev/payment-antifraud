FactoryBot.define do
  factory :fraud_report do
    registration_number { '12345678911' }
    description { 'CALOTEIRO' }
    status { :pending }
  end
end
