class AddIndexToComments < ActiveRecord::Migration
  def change
    add_index :comments, :user_id
    add_index :comments, :post_id
    add_index "comments", ["created_at"]
  end
end
