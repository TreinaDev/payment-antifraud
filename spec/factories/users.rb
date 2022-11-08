FactoryBot.define do
  factory :user do
    email { "#{SecureRandom.alphanumeric(8)}@paolaseguros.com.br" }
    password { 'password' }
    name { 'Luis Inacio Lula da Silva' }
    registration_number { '39439419203' }
    after(:build) do |user|
      class << user
        def consult_insurance_company_api_for_email_validation; end
      end
    end
  end
end
