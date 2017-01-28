class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :youtube_video_id
      t.text :text
      t.integer :reply, default: 0

      t.timestamps
    end
  end
end
