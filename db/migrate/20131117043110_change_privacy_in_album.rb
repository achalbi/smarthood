class ChangePrivacyInAlbum < ActiveRecord::Migration
  def change
    change_column :albums, :privacy, :integer
  end
end
