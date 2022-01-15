class UniqueIndexesForTokens < ActiveRecord::Migration[7.0]
  def change
    add_index :feeds, :token, unique: true
    add_index :posts, :token, unique: true
  end
end
