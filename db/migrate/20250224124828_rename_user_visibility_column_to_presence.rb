class RenameUserVisibilityColumnToPresence < ActiveRecord::Migration[8.0]
  def change
    rename_column :users, :visibility, :presence
  end
end
