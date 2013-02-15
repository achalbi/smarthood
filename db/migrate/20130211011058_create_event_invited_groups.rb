class CreateEventInvitedGroups < ActiveRecord::Migration
  def change
    create_table :event_invited_groups do |t|
      t.integer :event_id
      t.integer :group_id

      t.timestamps
    end
    add_index :event_invited_groups, :event_id
    add_index :event_invited_groups, :group_id
    add_index :event_invited_groups, [:event_id, :group_id], unique: true

  end
end
