class AddUsersColumnNoticeemail < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :notice_email, :boolean, default: true, null: false
  end
end
