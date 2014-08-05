class AddIndexToActivitydetails < ActiveRecord::Migration
  def change
    add_index :activitydetails, :activity_id
    add_index "activitydetails", ["activity_id", "user_id"], :name => "index_activitydetails_on_activity_id_and_user_id"
	add_index "activitydetails", ["activity_id", "group_id"], :name => "index_activitydetails_on_activity_id_and_group_id"
  end
end
