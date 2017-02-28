class YoutubeVideosController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  before_action :set_youtube, only: [:show, :edit, :update, :destroy, :like]

  def new
    user_level_check(2)
    @youtube = YoutubeVideo.new
    @youtube.youtube_video_tags.build
  end

  def create
    user_level_check(2)
    @youtube = YoutubeVideo.new(youtube_params)
    @youtube.user_id = current_user.id

    if @youtube.save
      #同じピックアップレベルの他の動画があればピックアップレベルを0にする
      old_pickup_video = YoutubeVideo.where('pickup_level = ? AND id <> ?',
        params[:youtube_video][:pickup_level],
        @youtube.id)
      old_pickup_video.each do |opv|
        opv.pickup_level = 0
        opv.save
      end
      
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
    user_level_check(2)
    @youtube.youtube_video_tags.build
  end

  def update
    user_level_check(2)
    #同じピックアップレベルの他の動画があればピックアップレベルを0にする
    old_pickup_video = YoutubeVideo.where('pickup_level = ? AND id <> ?',
      params[:youtube_video][:pickup_level],
      @youtube.id)
    old_pickup_video.each do |opv|
      opv.pickup_level = 0
      opv.save
    end

    if @youtube.update(youtube_params)
      redirect_to @youtube
    else
      render 'edit'
    end
  end

  def destroy
    user_level_check(2)
    @youtube.destroy
    redirect_to bits_path
  end

  def show
    @comment = Comment.new
    @comments = Comment.where('youtube_video_id = ?', params[:id]).order('created_at desc')
    @replys = @comments.where('reply != ?', 0).reorder('created_at asc')
    @likes = Like.where('youtube_video_id = ?', params[:id])
    if user_signed_in?
      history_exitence = ViewHistory.where('user_id = ? AND youtube_video_id = ?', current_user.id, params[:id]).exists?
      unless history_exitence
        ViewHistory.create(:user_id => current_user.id, :youtube_video_id => params[:id])
      else
        ViewHistory.where('user_id = ? AND youtube_video_id = ?', current_user.id, params[:id]).first.update(:updated_at => Time.now)
      end
    end
    impressionist(@youtube, nil, :unique => [:session_hash])
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
      .limit(20)
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

  def like
    unless @youtube.like_user(current_user.id)
      @like = Like.create(user_id: current_user.id, youtube_video_id: params[:id])
    else
      @like = current_user.likes.find_by(youtube_video_id: params[:id])
      @like.destroy
    end
      @likes = Like.where(youtube_video_id: params[:id])
  end

  private
    def set_youtube
      @youtube = YoutubeVideo.find(params[:id])
    end

    def youtube_params
      params.require(:youtube_video).permit(:title,
        :url,
        :text,
        :pickup_level,
        :category,
        :catchphrase,
        :poster_comment,
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
