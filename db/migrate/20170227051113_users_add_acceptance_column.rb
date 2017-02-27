class UsersAddAcceptanceColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :acceptance, :boolean, default: true, null: false
  end
end
