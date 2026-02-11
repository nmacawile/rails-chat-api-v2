class CreatePresenceConnections < ActiveRecord::Migration[8.0]
  def change
    create_table :presence_connections do |t|
      t.references :user, null: false, foreign_key: true
      t.string :connection_id, null: false
      t.datetime :last_seen, null: false

      t.timestamps
    end

    add_index :presence_connections, [:user_id, :connection_id], unique: true
  end
end
