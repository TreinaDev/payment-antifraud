FactoryBot.define do
  factory :user do
    email { 'usuario@antifraudsystem.com.br' }
    password { 'password' }
    name { 'Luis Inacio Lula da Silva' }
    registration_number { '39439419203' }
  end
end
