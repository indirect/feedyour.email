class AddExpiredAtToFeeds < ActiveRecord::Migration[7.2]
  def change
    add_column :feeds, :expired_at, :timestamp

    Feed.where("fetched_at < ?", 3.months.ago).find_each do |feed|
      feed.expire_if_stale!
    end
  end
end
