class RemoveUserGroupIdFromGroupposts < ActiveRecord::Migration
  def up
    remove_column :groupposts, :user_group_id
  end

  def down
    add_column :groupposts, :user_group_id, :string
  end
end
