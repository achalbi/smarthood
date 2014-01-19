class RemoveBsicsFromBuysellItem < ActiveRecord::Migration
  def up
    remove_column :buysell_items, :buysell_item_category_subcategory_id
  end

  def down
    add_column :buysell_items, :buysell_item_category_subcategory_id, :integer
  end
end
