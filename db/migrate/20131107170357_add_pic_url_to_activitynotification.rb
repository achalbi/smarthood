class AddPicUrlToActivitynotification < ActiveRecord::Migration
  def change
    add_column :activitynotifications, :pic_url, :string
  end
end
