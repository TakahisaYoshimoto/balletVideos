class BitsController < ApplicationController
  before_action :authenticate_user!, only: [:inquiry, :send_support_mail]

  def index
    rand_pic = YoutubeVideo.where('pickup_level > 0 AND pickup_level < 21').count
    i = rand(rand_pic)
    @pic_youtubes = YoutubeVideo.where('pickup_level > ? AND pickup_level < ?', 0, 21)
      .order('pickup_level asc')
      .limit(2)
      .offset(i)
    @youtubes = YoutubeVideo.where('pickup_level > ? OR pickup_level = ? OR pickup_level IS NULL', 21, 0)
      .order('created_at desc')
      .limit(11)
      .offset(0)
    @search_params = ""

    @boards = Board.all.order('created_at desc').limit(9).offset(0).includes(:user).includes(:board_tags)
    @top_img_text_a = SiteConfiguration.find_by(item: 'top_img_text_a')
    @top_img_text_b = SiteConfiguration.find_by(item: 'top_img_text_b')
  end

  def videotop
    rand_pic = YoutubeVideo.where('pickup_level > 0 AND pickup_level < 21').count
    i = rand(rand_pic - 1)
    @pic_youtubes = YoutubeVideo.where('pickup_level > ? AND pickup_level < ?', 0, 21)
      .order('pickup_level asc')
      .limit(2)
      .offset(i)
    @youtubes = YoutubeVideo.where('pickup_level > ? OR pickup_level = ? OR pickup_level IS NULL', 21, 0)
      .order('created_at desc')
      .limit(16)
      .offset(0)
    @search_params = ""

    @top_img_text_a = SiteConfiguration.find_by(item: 'top_img_text_a')
    @top_img_text_b = SiteConfiguration.find_by(item: 'top_img_text_b')
  end

  def all
    if params[:or] == "pv"
      @youtubes = YoutubeVideo.all
        .order('pv_count desc')
        .page(params[:page])
    else
      @youtubes = YoutubeVideo.all
        .order('created_at desc')
        .page(params[:page])
    end

    @search_params = ""
    @genre = ""
    @category_params = ""
    render 'videolist'
  end

  def like_videos
    unless user_signed_in?
      redirect_to new_user_session_path and return
    end

    if params[:or] == "pv"
      @youtubes = YoutubeVideo.joins(:likes)
        .where("likes.user_id = ?", current_user.id)
        .page(params[:page])
        .order(pv_count: :desc)
        .order(created_at: :desc)
    else
      @youtubes = YoutubeVideo.joins(:likes).joins(:view_histories)
        .where("likes.user_id = ?", current_user.id)
        .page(params[:page])
        .order('view_histories.updated_at desc')
        .order(created_at: :desc)
    end

    @search_params = ""
    @genre = "グッドした動画"
    @category_params = ""
    render 'videolist'
  end

  def view_histories
    unless user_signed_in?
      redirect_to new_user_session_path and return
    end

    if params[:or] == "pv"
      @youtubes = YoutubeVideo.joins(:view_histories)
        .where("view_histories.user_id = ?", current_user.id)
        .page(params[:page])
        .order(pv_count: :desc)
        .order(created_at: :desc)
    elsif params[:or] == "time"
      @youtubes = YoutubeVideo.joins(:view_histories)
        .where("view_histories.user_id = ?", current_user.id)
        .page(params[:page])
        .order(created_at: :desc)
    else
      @youtubes = YoutubeVideo.joins(:view_histories)
        .where("view_histories.user_id = ?", current_user.id)
        .page(params[:page])
        .order('view_histories.updated_at desc')
    end

    @search_params = ""
    @genre = "視聴履歴"
    @category_params = ""
    render 'videolist'
  end

  def Search
    if params[:search_params].blank?
      redirect_to all_bits_path and return
    end

    sp = params[:search_params].gsub("　"," ")#全角スペースを半角スペースに変換
    sp.chop! if sp[sp.length-1] == " "#最後の文字がスペースだったら削除
    sp = sp.gsub(" ","%,%")#半角スペースをカンマに変換(プレスホルダーの第二引数以降に使用する変数spに代入)
    sp = '%'+sp+'%'
    sp = sp.split(",")#ひとつの文字列だったspをカンマで区切って配列にする

    unless params[:category_params].blank?
      if params[:category_params] == '注目キーワード'
        cp = ""
        @category_params = params[:category_params]
      else
        cp = params[:category_params]
        @category_params = params[:category_params]
      end
    else
      cp = ""
      @category_params = ""
    end

    ph_title = "title like ?"
    c = sp.length-1
    c.times{ ph_title += " AND title like ?" } if sp.length > 1
    #動画を一致するタグが多い順にIDを配列で格納
    tag_keys = YoutubeVideo.joins(:youtube_video_tags)
      .where("#{ph_title}", *sp)
      .group(:id)
      .order('count_id desc')
      .limit(10)
      .offset(0)
      .count(:id).keys

    if params[:or] == "pv"
      @youtubes = YoutubeVideo.joins(:youtube_video_tags)
        .where("category like ?", "%"+cp+"%")
        .page(params[:page])
        .order(pv_count: :desc)
        .order(created_at: :desc)
        .distinct

      sp.each do |s|
        @youtubes = @youtubes.tag_search(s)
      end
    elsif params[:or] == "time"
      @youtubes = YoutubeVideo.joins(:youtube_video_tags)
        .where("category like ?", "%"+cp+"%")
        .page(params[:page])
        .order(created_at: :desc)
        .distinct

      sp.each do |s|
        @youtubes = @youtubes.tag_search(s)
      end
    else
      @youtubes = YoutubeVideo.joins(:youtube_video_tags)
        .where("category like ?", "%"+cp+"%")
        .page(params[:page])
        .order_as_specified(id: tag_keys)
        .order(created_at: :desc)
        .distinct

      sp.each do |s|
        @youtubes = @youtubes.tag_search(s)
      end
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

    @search_params = params[:search_params]
    @genre = params[:search_params]
    @genres = @genre.gsub(" ",",")#半角スペースをカンマに変換(プレスホルダーの第二引数以降に使用する変数spに代入)
    @genres = @genres.split(",")#ひとつの文字列だったspをカンマで区切って配列にする
    render 'videolist'
  end

  def attentionSearch
    tg = TopTagList.where('genre like ?', params[:search_params]).pluck(:tag_name)
    ph_tag = "youtube_video_tags.name like ?"
    c = tg.length-1
    c.times{ ph_tag += " OR youtube_video_tags.name like ?" } if tg.length > 1

    if params[:or] == "pv"
      @youtubes = YoutubeVideo.joins(:youtube_video_tags).where("#{ph_tag}", *tg)
        .page(params[:page])
        .order(pv_count: :desc)
        .order(created_at: :desc)
    else
      @youtubes = YoutubeVideo.joins(:youtube_video_tags).where("#{ph_tag}", *tg)
        .page(params[:page])
        .order(created_at: :desc)
    end

    @genre = params[:search_params]
    @category_params = ""
    render 'videolist'
  end

  def genreSearch
    if params[:or] == "pv"
      @youtubes = YoutubeVideo.where("category like ?", params[:search_params])
        .page(params[:page])
        .order(pv_count: :desc)
        .order(created_at: :desc)
    else
      @youtubes = YoutubeVideo.where("category like ?", params[:search_params])
        .page(params[:page])
        .order(created_at: :desc)
    end

    @relation_tags = TopTagList.where('genre like ?', params[:search_params]).order('hurigana asc').pluck(:tag_name)

    @genre = params[:search_params]
    @category_params = params[:search_params]
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

  def privacy_policy
    @privacy = SiteConfiguration.find_by(item: 'privacy_policy')
  end

  def operation_information
    @operation = SiteConfiguration.find_by(item: 'operation_information')
  end

  def terms
    @terms = SiteConfiguration.find_by(item: 'site_terms')
  end
end
