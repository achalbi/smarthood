class AddCommunityIdToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :community_id, :integer
  end
end
