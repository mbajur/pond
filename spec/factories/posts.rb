FactoryBot.define do
  factory :post do
    type { "Post::Url" }
    sequence(:url) { |n| "https://example#{n}.com" }

    transient do
      user { association :user }
    end

    fedipub_actor { user.fedipub_actor }

    trait :image do
      type { "Post::Image" }
    end

    trait :text do
      type { "Post::Text" }
    end
  end
end
