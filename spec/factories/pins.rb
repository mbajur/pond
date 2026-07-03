FactoryBot.define do
  factory :pin do
    association :user
    association :collection
  end
end
