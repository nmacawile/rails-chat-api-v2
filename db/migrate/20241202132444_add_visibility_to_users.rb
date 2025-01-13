class AddVisibilityToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users,
               :visibility,
               :boolean,
               null: false,
               default: false
    add_column :users,
               :last_seen,
               :datetime,
               null: false,
               default: -> { "CURRENT_TIMESTAMP" }
  end
end
