FactoryBot.define do
  factory :user_approval do
    refusal { "MyString" }
    user { nil }
  end
end
