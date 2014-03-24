class ChangeTitleDescriptionInIssueTracker < ActiveRecord::Migration
	def change
    	change_column :issue_trackers, :title, :text
    	change_column :issue_trackers, :description, :text
  	end
end
