class AddVideoColumnPostercomment < ActiveRecord::Migration[5.0]
  def change
    add_column :youtube_videos, :poster_comment, :text
  end
end
