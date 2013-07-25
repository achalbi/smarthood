class AddCommunityIdToEvent < ActiveRecord::Migration
  def change
    add_column :events, :community_id, :integer
  end
end
