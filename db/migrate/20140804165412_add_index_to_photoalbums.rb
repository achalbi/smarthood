class AddIndexToPhotoalbums < ActiveRecord::Migration
  def change
    add_index :photoalbums, :photo_id
    add_index :photoalbums, :album_id
    add_index "photoalbums", ["album_id", "photo_id"]
  end
end
