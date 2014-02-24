class AddIndexOnDescriptionToItems < ActiveRecord::Migration
  def change
    add_index :items, :description
  end
end
