FactoryBot.define do
  factory :collection do
    name { "Example Collection" }

    association :user
  end
end
