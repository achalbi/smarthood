class AddUsernameToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :albumable_type, :string
    add_column :albums, :albumable_id, :integer

  end
end
