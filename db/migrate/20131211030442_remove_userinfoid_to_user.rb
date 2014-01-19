class RemoveUserinfoidToUser < ActiveRecord::Migration
  def up
    remove_column :users, :user_info_id
  end

  def down
    add_column :users, :user_info_id, :integer
  end
end
