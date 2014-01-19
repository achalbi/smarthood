class AddContactNoToBuysellItem < ActiveRecord::Migration
  def change
    add_column :buysell_items, :contact_no, :string
  end
end
