class ViewhistoryIndexaddUserid < ActiveRecord::Migration[5.0]
  def change
    add_index :view_histories, :user_id
  end
end
