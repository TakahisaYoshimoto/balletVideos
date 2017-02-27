class CreateViewHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :view_histories do |t|
      t.integer :user_id, null: :false
      t.integer :youtube_video_id, null: :false

      t.timestamps
    end
  end
end
