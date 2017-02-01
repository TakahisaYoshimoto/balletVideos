class YoutubeVideosController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  before_action :set_youtube, only: [:show, :edit, :update, :destroy]

  def new
    user_level_check(2)
    @youtube = YoutubeVideo.new
    1.times{ @youtube.youtube_video_tags.build }
  end

  def create
    user_level_check(2)
    @youtube = YoutubeVideo.new(youtube_params)
    @youtube.user_id = current_user.id
    if @youtube.save
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
    user_level_check(2)
    tagcount = YoutubeVideoTag.where('youtube_video_id = ? AND master_tag = ?', @youtube.id, true).count
    tagcount = 1 - tagcount
    tagcount.times{ @youtube.youtube_video_tags.build }
  end

  def update
    user_level_check(2)
    if @youtube.update(youtube_params)
      redirect_to @youtube
    else
      render 'edit'
    end
  end

  def destroy
    @youtube.destroy
    redirect_to bits_path
  end

  def show
    @comment = Comment.new
    @comments = Comment.where('youtube_video_id = ?', params[:id]).order('created_at desc')
    @replys = @comments.where('reply != ?', 0).reorder('created_at asc')
    each_count = 0
    ph_tag = ""
    tags = Array.new
    @youtube.youtube_video_tags.each do |tag|
      tags.push(tag.name)
      if each_count > 0
        ph_tag += " OR " 
      end
      ph_tag += "youtube_video_tags.name like ?"
      each_count += 1
    end
    #表示する動画と同じタグが付いてる動画を一致するタグが多い順にIDを配列で格納
    relatedVideos_count = YoutubeVideo.joins(:youtube_video_tags)
      .where("#{ph_tag}", *tags)
      .group(:id)
      .order('count_id desc')
      .limit(10)
      .offset(0)
      .count(:id).keys
    #関連動画一覧のID一覧配列から表示する動画のIDを削除
    relatedVideos_count.each do |rvc|
      if rvc == params[:id].to_i
        relatedVideos_count.delete(rvc)
      end
    end 
    #上で作った一致タグが多い順のID配列でwhereして並び替え
    @relatedVideos = YoutubeVideo.where(id: relatedVideos_count)
      .order_as_specified(id: relatedVideos_count)
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

    def user_level_check(level)
      if current_user.nil?
        redirect_to bits_path and return
      end
      unless current_user.nil?
        if level > current_user.user_level
          redirect_to bits_path and return
        end
      end      
    end
end
