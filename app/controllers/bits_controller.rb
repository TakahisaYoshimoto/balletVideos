class BitsController < ApplicationController
  def index
    # @youtubes = YoutubeVideo.page(params[:page])
    #   .order(created_at: :desc)
    #   .includes(:youtube_video_tags)
    @youtubes = YoutubeVideo.where('pickup_level > ? AND pickup_level < ?', 0, 8).order('pickup_level asc').includes(:youtube_video_tags)
    # @tags = YoutubeVideoTag.group(:name)
    #   .order('count_name desc')
    #   .limit(20)
    #   .offset(0)
    #   .count('name')
    #   .keys
    @tags = TopTagList.all.order('genre asc, tag_name asc')
    @genres = TopTagList.select(:genre).order('genre asc').group(:genre)
    session[:search_params] = ""
  end

  def Search
    # @tags = YoutubeVideoTag.group(:name)
    #   .order('count_name desc')
    #   .limit(20)
    #   .offset(0)
    #   .count('name')
    #   .keys
    @tags = TopTagList.all.order('genre asc, tag_name asc')
    @genres = TopTagList.select(:genre).order('genre asc').group(:genre)
    
    sp = params[:search_params].gsub("　"," ")#全角スペースを半角スペースに変換
    sp.chop! if sp[sp.length-1] == " "#最後の文字がスペースだったら削除
    sp = sp.gsub(" ","%,%")#半角スペースをカンマに変換(プレスホルダーの第二引数以降に使用する変数spに代入)
    sp = '%'+sp+'%'
    sp = sp.split(",")#ひとつの文字列だったspをカンマで区切って配列にする
    ph_title = "title like ?"
    c = sp.length-1
    c.times{ ph_title += " AND title like ?" } if sp.length > 1

    tg = params[:search_params].gsub("　"," ")
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

    #動画を一致するタグが多い順にIDを配列で格納
    tag_keys = YoutubeVideo.joins(:youtube_video_tags)
      .where("#{ph_tag}", *tg)
      .group(:id)
      .order('count_id desc')
      .limit(10)
      .offset(0)
      .count(:id).keys

    @youtubes = YoutubeVideo.where("(#{ph_title}) OR (id IN (?))", *sp, youtubetags)
      .page(params[:page])
      .order_as_specified(id: tag_keys)
      .order(created_at: :desc)
      .includes(:youtube_video_tags)

    session[:search_params] = params[:search_params]
    render 'videolist'
  end
end
