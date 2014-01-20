class AddBsicToBuysellItem < ActiveRecord::Migration
  def change
    add_column :buysell_items, :buysell_item_category_id, :integer
  end
end
