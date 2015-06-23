class Create2Grouppost < ActiveRecord::Migration
  def change
    create_table :groupposts do |t|
      t.integer :post_id
      t.integer :group_id

      t.timestamps
    end
    add_index :groupposts, [:post_id, :group_id], unique: true
  end
end
