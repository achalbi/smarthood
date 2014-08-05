class AddIndexToGroups < ActiveRecord::Migration
  def change
    add_index :groups, :community_id
  end
end
