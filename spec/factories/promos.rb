FactoryBot.define do
  factory :promo do
    starting_date { Date.today }
    ending_date { Date.today + 7.days}
    name { Faker::Name.name }
    discount_percentage { Faker::Number.number(digits: 2) }
    discount_max { Faker::Commerce.price }
    product_list { 'dell, lenovo' }
    usages_max { Faker::Number.number(digits: 2) }
  end
end
