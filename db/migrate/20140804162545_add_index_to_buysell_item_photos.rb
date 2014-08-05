class AddIndexToBuysellItemPhotos < ActiveRecord::Migration
  def change
  	add_index "buysell_item_photos", ["buysell_item_id", "photo_id"]
  end
end
