class CreateActivitynotificationsettings < ActiveRecord::Migration
  def change
    create_table :activitynotificationsettings do |t|
      t.integer :user_id
      t.integer :community_id
      t.boolean :app
      t.boolean :email
      t.boolean :phone
      t.string :cu_mem_act
      t.string :act_inv_me
      t.string :following_user_act
      t.string :new_joiners

      t.timestamps
    end
  end
end
