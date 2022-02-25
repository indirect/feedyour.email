class AddPostColumns < ActiveRecord::Migration[7.0]
  def change
    change_table :posts, bulk: true do |t|
      t.string :from
      t.string :subject
      t.string :html_body
      t.string :text_body
    end
  end
end
