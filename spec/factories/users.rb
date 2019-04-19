FactoryBot.define do
  factory :user, aliases: [:owner] do
    sequence(:email) { |n| "test#{n}@example.com" }
    password { 'password' }
  end
end
