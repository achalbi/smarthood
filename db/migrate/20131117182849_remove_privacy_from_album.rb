class RemovePrivacyFromAlbum < ActiveRecord::Migration
  def up
    remove_column :albums, :privacy
  end

  def down
    add_column :albums, :privacy, :boolean
  end
end
