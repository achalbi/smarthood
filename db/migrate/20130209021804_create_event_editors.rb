class CreateEventEditors < ActiveRecord::Migration
  def change
    create_table :event_editors do |t|
      t.integer :event_id
      t.integer :user_id

      t.timestamps
    end
    add_index :event_editors, :event_id
    add_index :event_editors, :user_id
    add_index :event_editors, [:event_id, :user_id], unique: true
  end
end
