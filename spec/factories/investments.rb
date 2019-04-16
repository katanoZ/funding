FactoryBot.define do
  factory :investment do
    price { rand(1000..10_000) }
    association :user
    association :project
  end
end
