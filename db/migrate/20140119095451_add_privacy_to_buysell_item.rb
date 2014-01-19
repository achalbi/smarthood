class AddPrivacyToBuysellItem < ActiveRecord::Migration
  def change
    add_column :buysell_items, :privacy, :string
  end
end
