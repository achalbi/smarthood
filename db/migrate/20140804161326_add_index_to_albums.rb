class AddIndexToAlbums < ActiveRecord::Migration
  def change
    add_index :albums, :user_id
    add_index "albums", ["albumable_id", "albumable_type"]
  end
end
