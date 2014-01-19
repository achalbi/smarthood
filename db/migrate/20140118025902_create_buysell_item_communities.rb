class CreateBuysellItemCommunities < ActiveRecord::Migration
  def change
    create_table :buysell_item_communities do |t|
      t.integer :buysell_item_id
      t.integer :community_id

      t.timestamps
    end
  end
end
