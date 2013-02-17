class CreateActivityposts < ActiveRecord::Migration
  def change
    create_table :activityposts do |t|
      t.integer :post_id
      t.integer :activity_id

      t.timestamps
    end
     add_index :activityposts, :post_id
    add_index :activityposts, :activity_id
    add_index :activityposts, [:post_id, :activity_id], unique: true

  end
end
