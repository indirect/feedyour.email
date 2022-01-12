class PostsController < ApplicationController

  def index
    @feed = Feed.find_by_token(params[:feed_id])
    @posts = @feed.posts
  end

  def show
    @post = Post.where(token: params[:id]).first
    render inline: @post.payload["raw_html"]
  end

end
