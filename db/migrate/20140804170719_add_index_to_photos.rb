class AddIndexToPhotos < ActiveRecord::Migration
  def change
    add_index :photos, :post_id
    add_index :photos, :user_id
  end
end
