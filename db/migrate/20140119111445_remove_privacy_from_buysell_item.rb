class RemovePrivacyFromBuysellItem < ActiveRecord::Migration
  def up
    remove_column :buysell_items, :privacy
  end

  def down
    add_column :buysell_items, :privacy, :string
  end
end
