class AddIndexToEventdetails < ActiveRecord::Migration
  def change
    add_index :eventdetails, :event_id
    add_index "eventdetails", ["event_id", "user_id"]
	add_index "eventdetails", ["event_id", "group_id"]
  end
end
