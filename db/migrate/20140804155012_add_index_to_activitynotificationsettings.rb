class AddIndexToActivitynotificationsettings < ActiveRecord::Migration
  def change
    add_index :activitynotificationsettings, :user_id
    add_index :activitynotificationsettings, :community_id
  end
end
