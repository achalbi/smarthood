class RemoveTypeFromIssueTracker < ActiveRecord::Migration
  def up
    remove_column :issue_trackers, :type
  end

  def down
    add_column :issue_trackers, :type, :string
  end
end
