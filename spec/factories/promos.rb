FactoryBot.define do
  factory :promo do
    starting_date { "2022-11-01" }
    ending_date { "2022-11-01" }
    name { 'Black Friday' }
    discount_percentage { 5 }
    discount_max { 50 }
    product_list { "MyString" }
    usages_max { 10 }
    voucher { "Black123" }
  end
end
