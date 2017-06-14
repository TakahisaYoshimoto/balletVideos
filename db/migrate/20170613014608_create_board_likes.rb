class CreateBoardLikes < ActiveRecord::Migration[5.0]
  def change
    create_table :board_likes do |t|
      t.integer :user_id
      t.string :board_id

      t.timestamps
    end
  end
end
