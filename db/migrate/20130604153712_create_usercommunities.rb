class CreateUsercommunities < ActiveRecord::Migration
  def change
    create_table :usercommunities do |t|
      t.integer :community_id
      t.integer :user_id
      t.string :status

      t.timestamps
    end
  end
end
