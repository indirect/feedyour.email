atom_feed do |feed|
  feed.title @feed.name
  feed.updated @feed.posts.last.updated_at

  @feed.posts.limit(100).each do |post|
    feed.entry(post) do |entry|
      entry.author do |author|
        author.name post.from_name
        author.email post.from_email
      end
      entry.title(post.title)
      entry.content(post.html, type: "html")
    end
  end
end
