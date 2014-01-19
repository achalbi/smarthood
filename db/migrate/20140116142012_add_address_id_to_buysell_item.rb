class AddAddressIdToBuysellItem < ActiveRecord::Migration
  def change
    add_column :buysell_items, :address_id, :integer
  end
end
