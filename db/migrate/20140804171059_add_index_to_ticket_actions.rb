class AddIndexToTicketActions < ActiveRecord::Migration
  def change
    add_index :ticket_actions, :description
  end
end
