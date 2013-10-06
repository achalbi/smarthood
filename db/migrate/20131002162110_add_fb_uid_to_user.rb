class AddFbUidToUser < ActiveRecord::Migration
  def change
    add_column :users, :fb_uid, :string
  end
end
