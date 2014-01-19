class RemoveScopeFromBuysellItem < ActiveRecord::Migration
  def up
    remove_column :buysell_items, :scope
  end

  def down
    add_column :buysell_items, :scope, :string
  end
end
