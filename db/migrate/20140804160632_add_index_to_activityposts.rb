class AddIndexToActivityposts < ActiveRecord::Migration
  def change
    add_index :activityposts, :event_id
    add_index "activityposts", ["post_id", "event_id"], :unique=>true
  end
end
