class YoutubevideoAddVideotimeColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :youtube_videos, :video_time, :string
  end
end
