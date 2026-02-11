class RemovePresenceFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :presence, :boolean
  end
end
