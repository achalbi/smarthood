class CreateCommunityposts < ActiveRecord::Migration
  def change
    create_table :communityposts do |t|
      t.integer :post_id
      t.integer :community_id

      t.timestamps
    end
  end
end
