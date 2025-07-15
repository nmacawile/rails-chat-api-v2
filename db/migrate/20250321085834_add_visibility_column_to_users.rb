class AddVisibilityColumnToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users,
               :visibility,
               :boolean,
               null: false,
               default: true
  end
end
