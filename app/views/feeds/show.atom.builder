atom_feed root_url: subdomain_posts_url(@feed) do |atom|
  atom.title @feed.name
  atom.updated @feed.posts.last&.updated_at || @feed.updated_at
  atom.icon @feed.favicon_url if @feed.favicon_url

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
