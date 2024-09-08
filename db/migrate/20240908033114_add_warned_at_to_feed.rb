class AddWarnedAtToFeed < ActiveRecord::Migration[7.2]
  def change
    add_column :feeds, :warned_at, :timestamp
  end
end
