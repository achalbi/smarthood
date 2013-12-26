class RemoveSnLinkFromUserInfo < ActiveRecord::Migration
  def up
    remove_column :user_infos, :sn_link
  end

  def down
    add_column :user_infos, :sn_link, :integer
  end
end
