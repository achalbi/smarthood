class AddConditionToBuysellItem < ActiveRecord::Migration
  def change
    add_column :buysell_items, :condition, :string
  end
end
