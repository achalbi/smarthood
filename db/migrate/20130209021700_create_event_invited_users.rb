class CreateEventInvitedUsers < ActiveRecord::Migration
  def change
    create_table :event_invited_users do |t|
      t.integer :event_id
      t.integer :user_id

      t.timestamps
    end
    add_index :event_invited_users, :event_id
    add_index :event_invited_users, :user_id
    add_index :event_invited_users, [:event_id, :user_id], unique: true

  end
end
