class AddUserIdToBuysellItem < ActiveRecord::Migration
  def change
    add_column :buysell_items, :user_id, :integer
  end
end
