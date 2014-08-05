class AddIndexToBuysellItemCategorySubcategories < ActiveRecord::Migration
  def change
    add_index :buysell_item_category_subcategories, :buysell_item_category_id, :name => "index_b_i_c"
    add_index :buysell_item_category_subcategories, :buysell_item_subcategory_id, :name => "index_b_i_s"
    add_index "buysell_item_category_subcategories", [ "buysell_item_category_id", "buysell_item_subcategory_id"], :name => "index_b_i_c_b_i_s"
  end
end
