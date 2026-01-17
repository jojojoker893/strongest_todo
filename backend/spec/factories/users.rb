FactoryBot.define do
  factory :user do
    name { "user_name" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "123456" }

    trait :invalid_user do
      name { "" }
      email { "aaaa" }
      password { "1" }
    end

    trait :update_user do
      name { "update_name" }
      email { "update@example.com" }
      password { "update_123456" }
    end
  end
end
