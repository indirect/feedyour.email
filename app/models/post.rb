class Post < ApplicationRecord
  belongs_to :feed

  def title
    payload["subject"]
  end

  def html
    payload["raw_html"]
  end
end
