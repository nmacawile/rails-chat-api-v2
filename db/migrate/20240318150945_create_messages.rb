class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.references :user
      t.references :messageable, polymorphic: true
      t.text :content

      t.timestamps

      t.index [:messageable_id, :created_at]
    end
  end
end
