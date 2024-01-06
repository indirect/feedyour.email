class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.belongs_to :feed
      t.json :payload
      t.string :token, null: false, unique: true

      t.timestamps
    end
  end
end
