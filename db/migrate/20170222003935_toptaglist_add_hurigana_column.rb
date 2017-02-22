class ToptaglistAddHuriganaColumn < ActiveRecord::Migration[5.0]
  def change
    remove_column :top_tag_lists, :order_num, :integer
    add_column :top_tag_lists, :hurigana, :string
  end
end
