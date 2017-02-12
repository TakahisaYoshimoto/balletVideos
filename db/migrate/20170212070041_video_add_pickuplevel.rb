class VideoAddPickuplevel < ActiveRecord::Migration[5.0]
  def change
    add_column :youtube_videos, :pickup_level, :integer
  end
end
