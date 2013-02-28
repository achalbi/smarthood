class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :title
      t.text :description
      t.string :privacy
      t.integer :user_id
      t.integer :cover_photo_id
      t.string :type

      t.timestamps
    end
  end
end
