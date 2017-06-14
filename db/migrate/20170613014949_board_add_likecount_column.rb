class BoardAddLikecountColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :boards, :likes_count, :integer
  end
end
