class AddIndexToBuysellItemCommunities < ActiveRecord::Migration
  def change
  add_index "buysell_item_communities", ["buysell_item_id", "community_id"], :name => "index_b_i_com"
  end
end
