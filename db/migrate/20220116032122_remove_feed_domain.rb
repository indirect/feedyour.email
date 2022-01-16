class RemoveFeedDomain < ActiveRecord::Migration[7.0]
  def change
    remove_column :feeds, :domain, :string
  end
end
