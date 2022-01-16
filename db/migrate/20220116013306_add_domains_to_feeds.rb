class AddDomainsToFeeds < ActiveRecord::Migration[7.0]
  def change
    add_column :feeds, :domain, :text
  end
end
