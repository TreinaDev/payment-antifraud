FactoryBot.define do
  factory :payment_method do
    name { 'Laranja' }
    tax_percentage { 5 }
    tax_maximum { 100 }
    max_parcels { 12 }
    payment_type { 'Cartão de Crédito' }
    status { :active }
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec/support/icone_cartao_credito_azul.jpg')) }
  end
end
