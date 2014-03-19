class AddDownloadlinkToAlbum < ActiveRecord::Migration
  def change
    add_column :albums, :downloadlink, :string
  end
end
