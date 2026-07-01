FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "example#{n}" }
    sequence(:email_address) { |n| "example#{n}@example.com" }
  end
end
