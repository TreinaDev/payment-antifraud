FactoryBot.define do
  factory :payment_method do
    name { 'Laranja' }
    tax_percentage { 5 }
    tax_maximum { 100 }
    payment_type { 'Cartão de Crédito' }
    status { :active }
  end
end
