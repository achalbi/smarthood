class AddIndexToAuthentications < ActiveRecord::Migration
  def change
    add_index :authentications, :user_id
    add_index :authentications, :uid
  end
end
