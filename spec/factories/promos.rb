FactoryBot.define do
  factory :promo do
    starting_date { Faker::Date.in_date_period  }
    ending_date { Faker::Date.in_date_period  }
    name { Faker::Name.name }
    discount_percentage { Faker::Number.number(digits: 2) }
    discount_max { Faker::Commerce.price }
    product_list { 'dell, lenovo' }
    usages_max { Faker::Number.number(digits: 2) }
  end
end
