class AddIndexToUserGroups < ActiveRecord::Migration
  def change
  	add_index :user_groups, [:invitation, :is_admin]
  end
end
