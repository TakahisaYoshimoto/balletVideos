class CreateBoardTags < ActiveRecord::Migration[5.0]
  def change
    create_table :board_tags do |t|
      t.integer :board_id
      t.string :name

      t.timestamps
    end
  end
end
