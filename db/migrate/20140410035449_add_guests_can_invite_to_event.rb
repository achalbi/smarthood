class AddGuestsCanInviteToEvent < ActiveRecord::Migration
  def change
    add_column :events, :GuestsCanInvite, :boolean
  end
end
