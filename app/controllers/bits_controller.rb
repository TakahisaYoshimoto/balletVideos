class BitsController < ApplicationController
  def index
    @youtubes = YoutubeVideo.all
    session[:search_title_params] = ""
    session[:search_tag_params] = ""
  end

  def Search
    sp = params[:search_title].gsub("　"," ")#全角スペースを半角スペースに変換
    sp2 = sp.gsub(" ","%,%")#半角スペースをカンマに変換(プレスホルダーの第二引数以降に使用する変数sp2に代入)
    sp2 = '%'+sp2+'%'
    sp2 = sp2.split(",")#ひとつの文字列だったsp2をカンマで区切って配列にする
    ph_title = "title like ?"
    sp.count(" ").times{
      ph_title += " AND title like ?"
    }
    unless params[:search_tag].blank?
      tg = params[:search_tag].gsub("　"," ")
      tg2 = tg.gsub(" ","%,%")
      tg2 = '%'+tg2+'%'
      tg2 = tg2.split(",")
      ph_tag = "youtube_video_tags.name like ?"
      tg.count(" ").times{
        ph_tag += " OR youtube_video_tags.name like ?"
      }

      @youtubes = YoutubeVideo.includes(:youtube_video_tags)
                  .where("((#{ph_title}) AND (#{ph_tag}))",
                         *sp2,*tg2).references(:youtube_video_tags)#引数に配列を渡す時に先頭に*をつけると展開されて要素の数だけ引数の数も増えて渡される
    else
      @youtubes = YoutubeVideo.includes(:youtube_video_tags)
                  .where("#{ph_title}",
                         *sp2).references(:youtube_video_tags)#引数に配列を渡す時に先頭に*をつけると展開されて要素の数だけ引数の数も増えて渡される
    end
  else

    #@youtubes = YoutubeVideo.where('title like ?', '%' + params[:search_title] + '%')
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
