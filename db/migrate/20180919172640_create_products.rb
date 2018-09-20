class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :user_id
      t.string :sku_id
      t.string :price
      t.string :categories, array: true, default: []
      t.string :tags, array: true, default: []
      t.date :expire_date
      t.timestamps
    end
  end
end
