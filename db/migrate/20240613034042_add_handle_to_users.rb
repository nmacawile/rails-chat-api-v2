class MigrationUser < ActiveRecord::Base
  self.table_name = "users"
end

class AddHandleToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :handle, :citext

    reversible do |dir|
      dir.up do
        MigrationUser.reset_column_information

        MigrationUser.find_each do |user|
          handle = "#{user.first_name.downcase}.#{user.last_name.downcase}#{user.id}"
          user.update_columns(handle: handle)
        end

        change_column_null :users, :handle, false
        add_index :users, :handle, unique: true
      end

      dir.down do
        remove_index :users, :handle
        remove_column :users, :handle
      end
    end
  end
end
