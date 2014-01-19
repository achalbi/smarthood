class CreateBuysellItems < ActiveRecord::Migration
  def change
    create_table :buysell_items do |t|
      t.string :name
      t.string :description
      t.integer :buysell_item_category_subcategory_id
      t.integer :price
      t.string :currency
      t.string :type
      t.string :scope
      t.string :address
      t.string :notes

      t.timestamps
    end
  end
end
