class PostsController < ApplicationController

  def show
    @post = Post.where(token: params[:id]).first
    render inline: @post.payload["raw_html"]
  end

end
