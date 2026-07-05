FactoryBot.define do
  factory :post do
    sequence(:url) { |n| "https://example#{n}.com" }

    association :user
  end
end
