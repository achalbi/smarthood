class AddTitleToIssueTracker < ActiveRecord::Migration
  def change
    add_column :issue_trackers, :title, :string
  end
end
