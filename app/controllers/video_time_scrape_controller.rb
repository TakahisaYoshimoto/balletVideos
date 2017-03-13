class VideoTimeScrapeController < ApplicationController
  # URLにアクセスするためのライブラリの読み込み
  require 'open-uri'
  # Nokogiriライブラリの読み込み
  require 'nokogiri'
  
  def index
    redirect_to root_path and return if user_level_check(2)

    youtube_videos = YoutubeVideo.all
    youtube_videos.each do |youtube_video|
      url = youtube_video.url
      video = Nokogiri::HTML.parse(url_set(url), nil, 'utf-8')
      video_time = video.css('#watch7-content > meta[itemprop="duration"]').attr('content').value
      video_time.gsub!('PT','')
      video_time.gsub!('M',':')
      video_time.gsub!('S','')
      if video_time[-2, 1] == ":"
        video_time.gsub!(':', ':0')
      end

      youtube_video.video_time = video_time
      youtube_video.save
    end
  end

  private
    def url_set(url)
      charset = nil
      html = open(url) do |f|
        charset = f.charset # 文字種別を取得
        f.read # htmlを読み込んで変数htmlに渡す
      end
      return html
    end
end
