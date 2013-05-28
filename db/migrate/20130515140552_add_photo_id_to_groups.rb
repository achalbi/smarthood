class AddPhotoIdToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :photo_id, :integer
  end
end
