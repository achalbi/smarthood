class AddUserAndTitleAndDescriptionToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :user_id, :integer
    add_column :photos, :title, :string
    add_column :photos, :description, :text
  end
end
