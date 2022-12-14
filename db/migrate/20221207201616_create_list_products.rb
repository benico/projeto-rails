class CreateListProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :list_products do |t|
      t.integer :shopping_list_id
      t.integer :product_id

      t.timestamps
    end
  end
end
