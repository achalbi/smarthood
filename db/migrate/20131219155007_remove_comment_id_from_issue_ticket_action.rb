class RemoveCommentIdFromIssueTicketAction < ActiveRecord::Migration
  def up
    remove_column :issue_ticket_actions, :comment_id
  end

  def down
    add_column :issue_ticket_actions, :comment_id, :integer
  end
end
