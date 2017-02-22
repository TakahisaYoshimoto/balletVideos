class ToptaglistAddOrdernumColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :top_tag_lists, :order_num, :integer
  end
end
