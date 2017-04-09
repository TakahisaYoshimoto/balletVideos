class BoardercommentAddDisplayColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :board_comments, :display, :boolean, default: true
  end
end
