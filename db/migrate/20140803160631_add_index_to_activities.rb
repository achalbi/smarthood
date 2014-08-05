class AddIndexToActivities < ActiveRecord::Migration
  def change
    add_index :activities, :starts_at
    add_index :activities, :event_id
  end
end
