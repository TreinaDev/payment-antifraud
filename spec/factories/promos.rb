FactoryBot.define do
  factory :promo do
    starting_date { Time.zone.today }
    ending_date { Time.zone.today + 7.days }
    name { Faker::Name.name }
    discount_percentage { Faker::Number.number(digits: 2) }
    discount_max { Faker::Number.number(digits: 4) }
    product_list { 'dell, lenovo' }
    usages_max { Faker::Number.number(digits: 2) }
  end
end
