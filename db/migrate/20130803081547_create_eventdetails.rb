class CreateEventdetails < ActiveRecord::Migration
  def change
    create_table :eventdetails do |t|
      t.integer :event_id
      t.integer :user_id
      t.integer :group_id
      t.boolean :is_admin
      t.string :status

      t.timestamps
    end
  end
end
