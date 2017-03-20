class CreateSiteConfigurations < ActiveRecord::Migration[5.0]
  def change
    create_table :site_configurations do |t|
      t.string :item
      t.string :summary
      t.text :contents

      t.timestamps
    end
  end
end
