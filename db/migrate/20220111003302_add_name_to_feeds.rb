class AddNameToFeeds < ActiveRecord::Migration[7.0]
  def change
    add_column :feeds, :name, :string, null: true
  end
end
