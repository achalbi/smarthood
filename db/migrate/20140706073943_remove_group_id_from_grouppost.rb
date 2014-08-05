class RemoveGroupIdFromGrouppost < ActiveRecord::Migration
  def up
  #  remove_column :groupposts, :group_id
  end

  def down
   # add_column :groupposts, :group_id, :string
  end
end
