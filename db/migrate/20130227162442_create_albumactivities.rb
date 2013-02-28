class CreateAlbumactivities < ActiveRecord::Migration
  def change
    create_table :albumactivities do |t|
      t.integer :activity_id
      t.integer :album_id

      t.timestamps
    end
  end
end
