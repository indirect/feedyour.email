class CreateFeeds < ActiveRecord::Migration[7.0]
  def change
    create_table :feeds do |t|
      t.string :token, null: false, unique: true
      t.timestamps
    end
  end
end
