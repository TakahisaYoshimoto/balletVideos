class ConfigurationDeleteTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :configurations
  end
end
