class CreateBuysellItemCategorySubcategories < ActiveRecord::Migration
  def change
    create_table :buysell_item_category_subcategories do |t|
      t.integer :buysell_item_category_id
      t.integer :buysell_item_subcategory_id

      t.timestamps
    end
  end
end
