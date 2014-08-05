class AddIndexToCommunityposts < ActiveRecord::Migration
  def change
    add_index :communityposts, :post_id
    add_index :communityposts, :community_id
    add_index "communityposts", ["post_id", "community_id"], :unique=>true
	add_index "communityposts", ["community_id", "post_id"], :unique=>true
  end
end
