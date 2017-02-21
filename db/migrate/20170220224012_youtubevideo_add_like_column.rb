class YoutubevideoAddLikeColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :youtube_videos, :likes_count, :integer
  end
end