class AddRuleConfirmColumnUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :rule_confirmed, :boolean, null: false
  end
end
