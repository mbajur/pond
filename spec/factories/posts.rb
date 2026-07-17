FactoryBot.define do
  factory :post do
    type { "Post::Url" }
    sequence(:url) { |n| "https://example#{n}.com" }

    association :user

    trait :image do
      type { "Post::Image" }
    end

    trait :text do
      type { "Post::Text" }
    end
  end
end
