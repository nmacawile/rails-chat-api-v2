class CreateJoins < ActiveRecord::Migration[7.1]
  def change
    create_table :joins do |t|
      t.references :user, foreign_key: true
      t.references :joinable, polymorphic: true

      t.timestamps

      t.index [:user_id, :joinable_id], unique: true
    end
  end
end
