class CreateBoardComments < ActiveRecord::Migration[5.0]
  def change
    create_table :board_comments do |t|
      t.text :text
      t.integer :user_id
      t.integer :board_id

      t.timestamps
    end
  end
end
