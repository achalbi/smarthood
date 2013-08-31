class AddEventIdToActivitypost < ActiveRecord::Migration
  def change
    add_column :activityposts, :event_id, :integer
  end
end
