FactoryBot.define do
  factory :payment_method do
    name { 'MyString' }
    tax_percentage { 1 }
    tax_maximum { 1 }
    type { '' }
    status { 1 }
  end
end
