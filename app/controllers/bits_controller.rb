class BitsController < ApplicationController
  def index
    @youtubes = YoutubeVideo.page(params[:page])
      .order(created_at: :desc)
      .includes(:youtube_video_tags)
    @tags = YoutubeVideoTag.group(:name)
      .order('count_name desc')
      .limit(20)
      .offset(0)
      .count('name')
      .keys
    session[:search_params] = ""
  end

  def Search
    @tags = YoutubeVideoTag.group(:name)
      .order('count_name desc')
      .limit(20)
      .offset(0)
      .count('name')
      .keys
    sp = params[:search_params].gsub("　"," ")#全角スペースを半角スペースに変換
    sp2 = sp.gsub(" ","%,%")#半角スペースをカンマに変換(プレスホルダーの第二引数以降に使用する変数sp2に代入)
    sp2 = '%'+sp2+'%'
    sp2 = sp2.split(",")#ひとつの文字列だったsp2をカンマで区切って配列にする
    ph_title = "title like ?"
    sp.count(" ").times{
      ph_title += " OR title like ?"
    }

    tg = params[:search_params].gsub("　"," ")
    tg2 = tg.gsub(" ",",")
    tg2 = tg2
    tg2 = tg2.split(",")
    ph_tag = "name like ?"
    tg.count(" ").times{
      ph_tag += " OR name like ?"
    }
    youtubetags = YoutubeVideoTag.select(:youtube_video_id)
      .where("#{ph_tag}", *tg2)
      .group(:youtube_video_id)
      .having('count(youtube_video_id) >= ?', tg2.length)

    #動画を一致するタグが多い順にIDを配列で格納
    tag_keys = YoutubeVideo.joins(:youtube_video_tags)
      .where("#{ph_tag}", *tg2)
      .group(:id)
      .order('count_id desc')
      .limit(10)
      .offset(0)
      .count(:id).keys

    @youtubes = YoutubeVideo.where("(#{ph_title}) OR (id IN (?))", *sp2, youtubetags)
      .page(params[:page])
      .order_as_specified(id: tag_keys)
      .order(created_at: :desc)
      .includes(:youtube_video_tags)

    session[:search_params] = params[:search_params]
    render 'index'
  end
end
