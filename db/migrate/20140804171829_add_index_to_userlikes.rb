class AddIndexToUserlikes < ActiveRecord::Migration
  def change
    add_index :userlikes, :user_id
    add_index "userlikes", ["likeable_id", "likeable_type"]
  end
end
