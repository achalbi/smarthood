class CreateActivitydetails < ActiveRecord::Migration
  def change
    create_table :activitydetails do |t|
      t.integer :activity_id
      t.integer :user_id
      t.integer :group_id

      t.timestamps
    end
  end
end
