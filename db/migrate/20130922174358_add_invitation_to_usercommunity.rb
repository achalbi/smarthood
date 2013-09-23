class AddInvitationToUsercommunity < ActiveRecord::Migration
  def change
    add_column :usercommunities, :invitation, :string
  end
end
