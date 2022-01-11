class FeedsController < ApplicationController
  before_action :set_feed, only: %i[ show edit update destroy ]

  def new
    @feed = Feed.new
  end

  def show
  end

  def create
    @feed = Feed.new(feed_params)

    respond_to do |format|
      if @feed.save
        format.html { redirect_to feed_url(@feed), notice: "Feed was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

end

private
# Use callbacks to share common setup or constraints between actions.
def set_feed
  @feed = Feed.where(token: params[:id]).first
end

# Only allow a list of trusted parameters through.
def feed_params
  params.fetch(:feed, {}).permit(:name)
end
