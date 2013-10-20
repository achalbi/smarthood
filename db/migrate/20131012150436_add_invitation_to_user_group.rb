class AddInvitationToUserGroup < ActiveRecord::Migration
  def change
    add_column :user_groups, :invitation, :string
  end
end
