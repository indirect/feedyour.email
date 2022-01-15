class AddFetchedToFeeds < ActiveRecord::Migration[7.0]
  def change
    add_column :feeds, :fetched_at, :datetime
    add_index :feeds, :fetched_at
  end
end
