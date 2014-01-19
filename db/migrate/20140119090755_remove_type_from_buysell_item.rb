class RemoveTypeFromBuysellItem < ActiveRecord::Migration
  def up
    remove_column :buysell_items, :type
  end

  def down
    add_column :buysell_items, :type, :string
  end
end
