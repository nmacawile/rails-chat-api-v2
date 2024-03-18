FactoryBot.define do
  factory :join do
    association(:user, factory: :user)

    trait :chat do
      association(:joinable, factory: :chat)
    end
  end
end
