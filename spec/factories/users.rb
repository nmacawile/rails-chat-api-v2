FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    handle { Faker::Internet.unique.username(specifier: 5..20) }
    visibility { true }
  end
end
