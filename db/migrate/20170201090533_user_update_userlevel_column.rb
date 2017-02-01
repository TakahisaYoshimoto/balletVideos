class UserUpdateUserlevelColumn < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :user_level, :integer, default: 1
  end
end
