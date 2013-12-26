class AddSnLinkIdFromUserInfo < ActiveRecord::Migration
  def change
    add_column :user_infos, :sn_link_id, :integer
  end
end
