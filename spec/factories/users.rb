FactoryBot.define do
  factory :user do
    email { "#{SecureRandom.alphanumeric(8)}@paolaseguros.com.br" }
    password { 'password' }
    name { Faker::Name.name }
    registration_number { (11.times.map { rand(1..9) }).join }
    status { :approved }
    after(:build) do |user|
      class << user
        def consult_insurance_company_api_for_email_validation; end
      end
    end
  end
end
