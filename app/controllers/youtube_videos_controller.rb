class YoutubeVideosController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :create, :update]
  before_action :set_youtube, only: [:show, :edit, :update]

  def new
    @youtube = YoutubeVideo.new
    10.times{ @youtube.youtube_video_tags.build }
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
    tagcount = YoutubeVideoTag.where('youtube_video_id = ? AND master_tag = ?', @youtube.id, true).count
    tagcount = 10 - tagcount
    tagcount.times{ @youtube.youtube_video_tags.build }
  end

  def update
    if @youtube.update(youtube_params)
      redirect_to @youtube
    else
      render 'edit'
    end
  end

  def show
  end

  private
    def set_youtube
      @youtube = YoutubeVideo.find(params[:id])
    end

    def youtube_params
      params.require(:youtube_video).permit(:title,
                                            :url,
                                            :text,
                                            youtube_video_tags_attributes: [:id, :name, :master_tag, :_destroy])
    end
end
