class AddThrottledAtToFeed < ActiveRecord::Migration[7.2]
  def change
    add_column :feeds, :throttled_at, :timestamp
  end
end
