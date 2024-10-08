cache ["v1", @feed, "atom"] do
  atom_feed root_url: feed_posts_url(@feed) do |atom|
    atom.title @feed.name
    atom.updated @feed.updated_at
    atom.icon @feed.favicon_url if @feed.favicon_url

    @feed.posts.limit(25).each do |post|
      atom.entry(post) do |entry|
        entry.author do |author|
          author.name post.from_name
          author.email post.from_email
        end
        entry.title(post.subject)
        entry.content(post.html_body, type: "html")
      end
    end
  end
end
