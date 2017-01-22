class CreateYoutubeVideoTags < ActiveRecord::Migration[5.0]
  def change
    create_table :youtube_video_tags do |t|
      t.integer :youtube_video_id
      t.string :name
      t.boolean :master_tag, default: false

      t.timestamps
    end
  end
end
