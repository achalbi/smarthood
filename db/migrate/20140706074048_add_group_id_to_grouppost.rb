class AddGroupIdToGrouppost < ActiveRecord::Migration
  def change
    add_column :groupposts, :group_id, :integer
  end
end
