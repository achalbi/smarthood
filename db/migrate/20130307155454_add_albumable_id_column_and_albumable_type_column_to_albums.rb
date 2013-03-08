class AddAlbumableIdColumnAndAlbumableTypeColumnToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :albumable_id, :integer
    add_column :albums, :albumable_type, :string
  end
end
