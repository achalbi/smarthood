class CreateBuysellItemPhotos < ActiveRecord::Migration
  def change
    create_table :buysell_item_photos do |t|
      t.integer :buysell_item_id
      t.integer :photo_id

      t.timestamps
    end
  end
end
