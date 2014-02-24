class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :description
      t.decimal :price, precision: 12, scale: 2
      t.integer :qoh
      t.integer :merchant_id

      t.timestamps
    end
  end
end
