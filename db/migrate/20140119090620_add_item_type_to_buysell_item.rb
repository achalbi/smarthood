class AddItemTypeToBuysellItem < ActiveRecord::Migration
  def change
    add_column :buysell_items, :item_type, :string
  end
end
