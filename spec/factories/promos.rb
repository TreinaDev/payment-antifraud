FactoryBot.define do
  factory :promo do
<<<<<<< HEAD
    starting_date { '2022-11-01' }
    ending_date { '2022-11-01' }
    name { 'MyString' }
    discount_percentage { 1 }
    discount_max { 1 }
    product_list { 'MyString' }
    usages_max { 1 }
    voucher { 'MyString' }
=======
    starting_date { "2022-11-01" }
    ending_date { "2022-11-01" }
    name { 'Black Friday' }
    discount_percentage { 5 }
    discount_max { 50 }
    product_list { "MyString" }
    usages_max { 10 }
    voucher { "Black123" }
>>>>>>> adiciona teste do index e cadastro
  end
end
