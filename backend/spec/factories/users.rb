FactoryBot.define do
  factory :user do
    name { "user_name" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "123456" }
  end
end