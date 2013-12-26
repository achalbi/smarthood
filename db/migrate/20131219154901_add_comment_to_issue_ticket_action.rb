class AddCommentToIssueTicketAction < ActiveRecord::Migration
  def change
    add_column :issue_ticket_actions, :comment, :string
  end
end
