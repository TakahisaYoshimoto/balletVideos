class CreateTopTagLists < ActiveRecord::Migration[5.0]
  def change
    create_table :top_tag_lists do |t|
      t.string :genre, default: "注目キーワード"
      t.string :tag_name

      t.timestamps
    end
  end
end
