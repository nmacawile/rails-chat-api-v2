class Join < ApplicationRecord
  belongs_to :user
  belongs_to :joinable, polymorphic: true
end
