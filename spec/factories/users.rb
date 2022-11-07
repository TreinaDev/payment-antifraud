FactoryBot.define do
  factory :user do
    email { "#{SecureRandom.alphanumeric(8)}@paolaseguros.com.br" }
    password { 'password' }
    name { 'Luis Inacio Lula da Silva' }
    registration_number { '39439419203' }
  end
end
