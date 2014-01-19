class AddPrivacy2ToBuysellItem < ActiveRecord::Migration
  def change
    add_column :buysell_items, :privacy, :integer
  end
end
