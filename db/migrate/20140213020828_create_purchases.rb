class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.string :name
      t.string :description
      t.decimal :price, precision: 12, scale: 2
      t.integer :qty
      t.string :merchant_address
      t.string :merchant_name

      t.timestamps
    end
  end
end
