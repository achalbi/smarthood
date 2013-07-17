class CreateCommunities < ActiveRecord::Migration
  def change
    create_table :communities do |t|
      t.integer :community_id
      t.integer :user_id
      t.integer :photo_id

      t.timestamps
    end
  end
end
