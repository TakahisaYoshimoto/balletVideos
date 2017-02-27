class BitsController < ApplicationController
  before_action :authenticate_user!, only: [:inquiry, :send_support_mail]

  def index
    @pic_youtubes = YoutubeVideo.where('pickup_level > ? AND pickup_level < ?', 0, 3)
      .order('pickup_level asc')
      .includes(:youtube_video_tags)
    @youtubes = YoutubeVideo.where('pickup_level > ? OR pickup_level = ? OR pickup_level IS NULL', 2, 0)
      .order('created_at desc')
      .limit(11)
      .offset(0)
      .includes(:youtube_video_tags)
    @tags = TopTagList.all.select(:genre, :tag_name).order('hurigana asc')
    session[:search_params] = ""
  end

  def all
    if params[:or] == "time"
      @youtubes = YoutubeVideo.all
        .order('created_at desc')
        .page(params[:page])
    else
      @youtubes = YoutubeVideo.all
        .order('pv_count desc')
        .page(params[:page])
    end
      
    @tags = TopTagList.all.select(:genre, :tag_name).order('hurigana asc')
    session[:search_params] = ""  
    render 'videolist'
  end

  def like_videos
    unless user_signed_in?
      redirect_to bits_path and return
    end

    if params[:or] == "pv"
      @youtubes = YoutubeVideo.joins(:likes)
        .where("likes.user_id = ?", current_user.id)
        .page(params[:page])
        .order(pv_count: :desc)
        .order(created_at: :desc)
    else
      @youtubes = YoutubeVideo.joins(:likes)
        .where("likes.user_id = ?", current_user.id)
        .page(params[:page])
        .order(created_at: :desc)
    end
    
    @tags = TopTagList.all.select(:genre, :tag_name).order('hurigana asc')
    session[:search_params] = ""
    render 'videolist'
  end

  def view_histories
    unless user_signed_in?
      redirect_to bits_path and return
    end

    if params[:or] == "pv"
      @youtubes = YoutubeVideo.joins(:view_histories)
        .where("view_histories.user_id = ?", current_user.id)
        .page(params[:page])
        .order(pv_count: :desc)
        .order(created_at: :desc)
    else
      @youtubes = YoutubeVideo.joins(:view_histories)
        .where("view_histories.user_id = ?", current_user.id)
        .page(params[:page])
        .order(created_at: :desc)
    end

    @tags = TopTagList.all.select(:genre, :tag_name).order('hurigana asc')
    session[:search_params] = ""
    render 'videolist'
  end

  def Search
    @tags = TopTagList.all.select(:genre, :tag_name).order('hurigana asc')

    if params[:search_params].blank?
      redirect_to all_bits_path and return
    end

    sp = params[:search_params].gsub("　"," ")#全角スペースを半角スペースに変換
    sp.chop! if sp[sp.length-1] == " "#最後の文字がスペースだったら削除
    sp = sp.gsub(" ","%,%")#半角スペースをカンマに変換(プレスホルダーの第二引数以降に使用する変数spに代入)
    sp = '%'+sp+'%'
    sp = sp.split(",")#ひとつの文字列だったspをカンマで区切って配列にする
    ph_title = "title like ?"
    c = sp.length-1
    c.times{ ph_title += " AND title like ?" } if sp.length > 1

    tg = params[:search_params]
    tg.gsub("　"," ")
    tg.chop! if tg[tg.length-1] == ","#最後の文字がスペースだったら削除
    tg = tg.gsub(" ",",")
    tg = tg.split(",")
    ph_tag = "name like ?"
    c = tg.length-1
    c.times{ ph_tag += " OR name like ?" } if tg.length > 1
    youtubetags = YoutubeVideoTag.select(:youtube_video_id)
      .where("#{ph_tag}", *tg)
      .group(:youtube_video_id)
      .having('count(youtube_video_id) >= ?', tg.length)

    unless params[:category_params].nil?
      cp = params[:category_params]
      session[:category_params] = params[:category_params]
    else
      cp = ""
      session[:category_params] = ""
    end

    #動画を一致するタグが多い順にIDを配列で格納
    tag_keys = YoutubeVideo.joins(:youtube_video_tags)
      .where("#{ph_tag}", *tg)
      .group(:id)
      .order('count_id desc')
      .limit(10)
      .offset(0)
      .count(:id).keys

    if params[:or] == "pv"
      @youtubes = YoutubeVideo.where("((#{ph_title}) OR (id IN (?))) AND (category like ?)", *sp, youtubetags, "%"+cp+"%")
        .page(params[:page])
        .order(pv_count: :desc)
        .order(created_at: :desc)
        .includes(:youtube_video_tags)
    elsif params[:or] == "time"
      @youtubes = YoutubeVideo.where("((#{ph_title}) OR (id IN (?))) AND (category like ?)", *sp, youtubetags, "%"+cp+"%")
        .page(params[:page])
        .order(created_at: :desc)
        .includes(:youtube_video_tags)
    else
      @youtubes = YoutubeVideo.where("((#{ph_title}) OR (id IN (?))) AND (category like ?)", *sp, youtubetags, "%"+cp+"%")
        .page(params[:page])
        .order_as_specified(id: tag_keys)
        .order(created_at: :desc)
        .includes(:youtube_video_tags)
    end

    #検索結果の動画についてるタグ一覧を取得、検索キーワードは除外
    @relation_tags = Array.new
    @youtubes.each do |youtube|
      youtube.youtube_video_tags.each do |tag|
        if @relation_tags.include?(tag.name) == false && tag.name != params[:search_params]
          @relation_tags.push(tag.name)
        end
      end
    end 

    session[:search_params] = params[:search_params]
    session[:genre] = params[:search_params]
    render 'videolist'
  end

  def attentionSearch
    @tags = TopTagList.all.select(:genre, :tag_name).order('hurigana asc')

    tg = TopTagList.all.where('genre like ?', params[:search_params]).pluck(:tag_name)
    ph_tag = "youtube_video_tags.name like ?"
    c = tg.length-1
    c.times{ ph_tag += " OR youtube_video_tags.name like ?" } if tg.length > 1

    if params[:or] == "pv"
      @youtubes = YoutubeVideo.joins(:youtube_video_tags).where("#{ph_tag}", *tg)
        .page(params[:page])
        .order(pv_count: :desc)
        .order(created_at: :desc)
        .includes(:youtube_video_tags)
    else
      @youtubes = YoutubeVideo.joins(:youtube_video_tags).where("#{ph_tag}", *tg)
        .page(params[:page])
        .order(created_at: :desc)
        .includes(:youtube_video_tags)
    end

    session[:genre] = params[:search_params]
    render 'videolist'
  end

  def genreSearch
    @tags = TopTagList.all.select(:genre, :tag_name).order('hurigana asc')

    if params[:or] == "pv"
      @youtubes = YoutubeVideo.where("category like ?", params[:search_params])
        .page(params[:page])
        .order(pv_count: :desc)
        .order(created_at: :desc)
        .includes(:youtube_video_tags)
    else
      @youtubes = YoutubeVideo.where("category like ?", params[:search_params])
        .page(params[:page])
        .order(created_at: :desc)
        .includes(:youtube_video_tags)
    end

    session[:genre] = params[:search_params]
    render 'videolist'
  end

  def inquiry
  end

  def inquiry_after
  end

  def send_support_mail
    @mail = SupportMailer.sendmail_support(params[:title],
      params[:text],
      current_user.username,
      current_user.email)
      .deliver
    redirect_to inquiry_after_bits_path
  end
end
