class CreateGroupposts < ActiveRecord::Migration
  def change
    create_table :groupposts do |t|
      t.integer :post_id
      t.integer :user_group_id

      t.timestamps
    end
     add_index :groupposts, :post_id
    add_index :groupposts, :user_group_id
    add_index :groupposts, [:post_id, :user_group_id], unique: true
  end
end
