class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.string :name
      t.string :item_id
      t.decimal :price, precision: 12, scale: 2
      t.integer :qty

      t.timestamps
    end
  end
end
