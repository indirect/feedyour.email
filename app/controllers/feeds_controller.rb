class FeedsController < ApplicationController
  def new
    @feed = Feed.new
  end

  def show
    @feed = Feed.find_by!(token: params[:id])
    expires_in 1.hour, public: true
    fresh_when(@feed)

    @feed.touch(:fetched_at) unless @feed.expired_at? || request.format.html?
  end

  def create
    @feed = Feed.new(feed_params)

    if @feed.save
      redirect_to feed_url(@feed), notice: "Feed was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def feed_params
    params.fetch(:feed, {}).permit(:name)
  end
end
