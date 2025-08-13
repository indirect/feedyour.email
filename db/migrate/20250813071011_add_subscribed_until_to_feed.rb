class AddSubscribedUntilToFeed < ActiveRecord::Migration[7.2]
  def change
    add_column :feeds, :subscribed_until, :datetime
  end
end
