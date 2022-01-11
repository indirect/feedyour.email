class CreateFeeds < ActiveRecord::Migration[7.0]
  def change
    enable_extension :citext
    create_table :feeds do |t|
      t.citext :token, null: false, unique: true
      t.timestamps
    end
  end
end
