class RemoveAddressFromBuysellItem < ActiveRecord::Migration
  def up
    remove_column :buysell_items, :address
  end

  def down
    add_column :buysell_items, :address, :string
  end
end
