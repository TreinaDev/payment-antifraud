FactoryBot.define do
  factory :promo do
    starting_date { "2022-11-01" }
    ending_date { "2022-11-01" }
    name { "MyString" }
    discount_percentage { 1 }
    discount_max { 1 }
    product_list { "MyString" }
    usages_max { 1 }
    voucher { "MyString" }
  end
end
