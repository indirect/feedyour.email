class FeedsController < ApplicationController
  def new
    @feed = Feed.new
  end

  def show
    @feed = Feed.find_by!(token: params[:id] || request.subdomain)
    @feed.touch(:fetched_at) if request.format == :atom
  end

  def favicon
    return redirect_to helpers.asset_path("favicon.ico") if request.subdomain.blank?

    redirect_to Feed.find_by!(token: request.subdomain).favicon_url, allow_other_host: true
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
