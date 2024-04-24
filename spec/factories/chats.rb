FactoryBot.define do
  factory :chat do
    transient do
      users { [] }
    end

    after(:create) do |chat, evaluator|
      evaluator.users.each do |user|
        chat.users << user
      end
    end
  end
end
