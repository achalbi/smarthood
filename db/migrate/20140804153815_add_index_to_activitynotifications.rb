class AddIndexToActivitynotifications < ActiveRecord::Migration
  def change
    add_index :activitynotifications, :recepient_id
    add_index :activitynotifications, :sender_id
  end
end
