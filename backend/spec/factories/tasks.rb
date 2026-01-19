FactoryBot.define do
  factory :task do
    title { "task_name" }
    description { "task_description" }
    category { "task_category" }
    status { :incomplete }
    visibility { :public_task }
    association :user

    trait :other_task do
      title { "other_task_name" }
      description { "other_task_description" }
      category { "other_task_category" }
      status { :incomplete }
      visibility { :private_task }
      association :user, :other_user
    end

    trait :invalid_task do
      title { " " }
      description { "invalid" }
      category { " " }
      status { :incomplete }
      visibility { :public_task }
      association :user
    end

  end
end
