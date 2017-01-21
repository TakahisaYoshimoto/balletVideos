class BitsController < ApplicationController
  def index
    @youtubes = YoutubeVideo.all
  end

  def show
  end

  def new
  end

  def edit
  end
end
