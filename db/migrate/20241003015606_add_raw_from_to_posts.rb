class AddRawFromToPosts < ActiveRecord::Migration[7.2]
  def change
    change_table :posts do |t|
      t.string :raw_from
    end
  end
end
