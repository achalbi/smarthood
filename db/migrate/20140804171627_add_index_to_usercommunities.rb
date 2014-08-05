class AddIndexToUsercommunities < ActiveRecord::Migration
  def change
    add_index :usercommunities, :user_id
    add_index :usercommunities, :community_id
    add_index :usercommunities, [:user_id], where: "status = active"
	add_index :usercommunities, [:community_id, :invitation]
	add_index :usercommunities, [:user_id, :invitation]
  end
end
