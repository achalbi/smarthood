class AddIndexes < ActiveRecord::Migration
  def up
  	 add_index :groupposts, :group_id
    add_index :groupposts, [:post_id, :group_id], unique: true

  end

  def down
  	 remove_index :groupposts, :group_id
    remove_index :groupposts, [:post_id, :group_id], unique: true

  end
end
