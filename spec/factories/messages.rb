FactoryBot.define do
  factory :message do
    association(:user, factory: :user)
    content { Faker::Lorem.paragraph }
  end
end
