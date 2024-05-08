class AddCompoundFirstNameAndLastNameIndexToUsers < ActiveRecord::Migration[7.1]
  def change
    add_index :users, [:first_name, :last_name], name: "index_on_full_name"
  end
end
