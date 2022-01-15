class AddLastFetchedToFeeds < ActiveRecord::Migration[7.0]
  def change
    add_column :feeds, :last_fetched, :datetime
    add_index :feeds, :last_fetched
  end
end
