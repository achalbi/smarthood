class AddIndexToUserInfos < ActiveRecord::Migration
  def change
    add_index :user_infos, :sn_link_id
    add_index :user_infos, :user_id
  end
end
