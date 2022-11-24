FactoryBot.define do
  factory :user do
    email { "#{SecureRandom.alphanumeric(8)}@paolaseguros.com.br" }
    password { 'password' }
    name { Faker::Name.name }
    registration_number { (11.times.map { rand(1..9) }).join }
    status { :approved }
  end
end
