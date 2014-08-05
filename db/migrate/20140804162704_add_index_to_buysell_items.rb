class AddIndexToBuysellItems < ActiveRecord::Migration
  def change
    add_index :buysell_items, :buysell_item_category_id, :name => "index_b_i_cat"
    add_index :buysell_items, :buysell_item_subcategory_id, :name => "index_b_i_subcat"
    add_index "buysell_items", [ "buysell_item_category_id", "buysell_item_subcategory_id"], :name => "index_b_i_cat_b_i_sub"
  end
end
