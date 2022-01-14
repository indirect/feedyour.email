atom_feed root_url: feed_posts_url(@feed) do |atom|
  atom.title @feed.name
  atom.updated @feed.posts.last&.updated_at || @feed.updated_at

  @feed.posts.limit(100).each do |post|
    atom.entry(post) do |entry|
      entry.author do |author|
        author.name post.from_name
        author.email post.from_email
      end
      entry.title(post.title)
      entry.content(post.html, type: "html")
    end
  end
end
