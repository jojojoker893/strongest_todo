FactoryBot.define do
  factory :task do
    title { "task_name" }
    description { "タスクの概要" }
    category { "タスクのカテゴリ" }
    association :user
  end
end