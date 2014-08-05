class AddIndexToBuysellItemComments < ActiveRecord::Migration
  def change
  	add_index "buysell_item_comments", ["buysell_item_id", "comment_id"], :name => "index_b_i_comments"
  end
end
