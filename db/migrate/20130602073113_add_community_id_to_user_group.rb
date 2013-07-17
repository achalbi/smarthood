class AddCommunityIdToUserGroup < ActiveRecord::Migration
  def change
    add_column :user_groups, :community_id, :integer
  end
end
