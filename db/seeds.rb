# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
def generate_user_data(n)
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  email = Faker::Internet.email(name: "#{first_name} #{last_name} #{n}")
  {
    first_name: first_name,
    last_name: last_name,
    email: email
  }
end

user = User.create!(**generate_user_data(0),
                    password: ENV["ACCOUNT_PASSWORD"])

10.times do |n|
  u = User.create!(**generate_user_data(n + 1),
                   password: ENV["ACCOUNT_PASSWORD"])
  c = Chat.create!(users: [user, u])
  
  if (n < 5)
    Message.create(content: Faker::Lorem.paragraph, messageable: c, user: user)
    Message.create(content: Faker::Lorem.paragraph, messageable: c, user: u)
  end
end