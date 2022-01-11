class CreateFeeds < ActiveRecord::Migration[7.0]
  def change
    create_table :feeds, id: :uuid do |t|

      t.timestamps
    end
  end
end
