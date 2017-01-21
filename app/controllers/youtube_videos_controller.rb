class YoutubeVideosController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :create, :update]

  def new
    @youtube = YoutubeVideo.new
  end

  def create
    @youtube = YoutubeVideo.new(youtube_params)
    @youtube.user_id = current_user.id
    if @youtube.save
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
  end

  private
    def set_youtube
      @youtube = YouyubeVideo.find(params[:id])
    end

    def youtube_params
      params.require(:youtube_video).permit(:title, :url, :text)
    end
end
