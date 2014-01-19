class AddBsisToBuysellItem < ActiveRecord::Migration
  def change
    add_column :buysell_items, :buysell_item_subcategory_id, :integer
  end
end
