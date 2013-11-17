class AddPrivacyToAlbum < ActiveRecord::Migration
  def change
    add_column :albums, :privacy, :integer
  end
end
