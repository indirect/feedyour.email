class AddIndexFeedIdUpdatedAtDescToPosts < ActiveRecord::Migration[7.0]
  def change
    add_index :posts, [:feed_id, :updated_at], order: {feed_id: :asc, updated_at: :desc}
  end
end
