class CreateYoutubeVideos < ActiveRecord::Migration[5.0]
  def change
    create_table :youtube_videos do |t|
      t.integer :user_id
      t.string :title
      t.text :url
      t.text :text

      t.timestamps
    end
  end
end
