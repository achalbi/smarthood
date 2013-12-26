class CreateIssueTicketActions < ActiveRecord::Migration
  def change
    create_table :issue_ticket_actions do |t|
      t.integer :issue_tracker_id
      t.integer :ticket_action_id
      t.integer :comment_id
      t.integer :user_id

      t.timestamps
    end
  end
end
