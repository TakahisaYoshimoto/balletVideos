class BoardsAddCommentsCounterColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :boards, :board_comments_count, :integer, default: 0
  end
end
