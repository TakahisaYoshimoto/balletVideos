class VideoAddColumnCatchphrase < ActiveRecord::Migration[5.0]
  def change
    add_column :youtube_videos, :catchphrase, :string
    add_column :youtube_videos, :category, :string
  end
end
