class AddIsAdminToUsercommunity < ActiveRecord::Migration
  def change
    add_column :usercommunities, :is_admin, :boolean
  end
end
