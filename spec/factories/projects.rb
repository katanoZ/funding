FactoryBot.define do
  factory :project do
    sequence(:name) { |i| "test_name#{i}" }
    sequence(:description) { |i| "test_description#{i}" }
    price { rand(10_000..100_000) }
    association :owner
  end
end
