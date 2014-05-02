class AddDownloadableToAlbum < ActiveRecord::Migration
  def change
    add_column :albums, :downloadable, :boolean
  end
end
