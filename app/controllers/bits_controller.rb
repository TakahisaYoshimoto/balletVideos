class BitsController < ApplicationController
  def index
    @youtubes = YoutubeVideo.all
    @tags = YoutubeVideoTag.group(:name).order('count_name desc').limit(10).offset(0).count('name').keys
    session[:search_title_params] = ""
    session[:search_tag_params] = ""
  end

  def Search
    @tags = YoutubeVideoTag.group(:name).order('count_name desc').limit(10).offset(0).count('name').keys
    sp = params[:search_title].gsub("　"," ")#全角スペースを半角スペースに変換
    sp2 = sp.gsub(" ","%,%")#半角スペースをカンマに変換(プレスホルダーの第二引数以降に使用する変数sp2に代入)
    sp2 = '%'+sp2+'%'
    sp2 = sp2.split(",")#ひとつの文字列だったsp2をカンマで区切って配列にする
    ph_title = "title like ?"
    sp.count(" ").times{
      ph_title += " AND title like ?"
    }
    unless params[:search_tag].blank?
      @youtubes = YoutubeVideo.where("#{ph_title}", *sp2)
      tg = params[:search_tag].gsub("　"," ")
      tg2 = tg.gsub(" ","%,%")
      tg2 = '%'+tg2+'%'
      tg2 = tg2.split(",")
      ph_tag = "name like ?"
      tg.count(" ").times{
        ph_tag += " OR name like ?"
      }
      @youtubetags = YoutubeVideoTag.select(:youtube_video_id)
                                    .where("#{ph_tag}", *tg2)
                                    .group(:youtube_video_id)
                                    .having('count(youtube_video_id) >= ?', tg2.length)
      @youtubes = @youtubes.where(id: @youtubetags)
    else
      @youtubes = YoutubeVideo.where("#{ph_title}", *sp2)#引数に配列を渡す時に先頭に*をつけると展開されて要素の数だけ引数の数も増えて渡される
    end
    session[:search_title_params] = params[:search_title]
    session[:search_tag_params] = params[:search_tag]
    render 'index'
  end

  def show
  end

  def new
  end

  def edit
  end
end
