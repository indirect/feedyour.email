class AddCompressedColumns < ActiveRecord::Migration[7.1]
  def change
    change_table :posts, bulk: true do |t|
      t.binary :compressed_html_body
      t.binary :compressed_text_body
    end
  end
end
