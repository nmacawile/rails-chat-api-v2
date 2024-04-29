class Chat < ApplicationRecord
  has_many :joins, as: :joinable,
                   dependent: :destroy
  has_many :messages, as: :messageable,
                      dependent: :destroy
  has_many :users, through: :joins
  belongs_to :latest_message, class_name: "Message",
                              optional: true
end
