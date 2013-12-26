class AddIssueTypeToIssueTracker < ActiveRecord::Migration
  def change
    add_column :issue_trackers, :issue_type, :string
  end
end
