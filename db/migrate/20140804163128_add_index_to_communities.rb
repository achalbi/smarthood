class AddIndexToCommunities < ActiveRecord::Migration
  def change
    add_index :communities, :user_id
    add_index :communities, :photo_id
  end
end
