class UserAddColumnPicturemin < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :picture, :picture_min
    add_column :users, :picture_lg, :string
  end
end
