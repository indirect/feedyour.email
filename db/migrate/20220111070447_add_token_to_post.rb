class AddTokenToPost < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :token, :citext, null: false, unique: true
  end
end
