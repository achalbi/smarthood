class CreatePhotoalbums < ActiveRecord::Migration
  def change
    create_table :photoalbums do |t|
      t.integer :photo_id
      t.integer :album_id

      t.timestamps
    end
  end
end
