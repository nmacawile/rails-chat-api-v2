class Chat < ApplicationRecord
  has_many :joins, as: :joinable,
                   dependent: :destroy
  has_many :users, through: :joins
end
