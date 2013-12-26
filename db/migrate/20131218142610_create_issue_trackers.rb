class CreateIssueTrackers < ActiveRecord::Migration
  def change
    create_table :issue_trackers do |t|
      t.string :ticket_id
      t.string :version
      t.string :description
      t.string :type
      t.string :module
      t.string :priority
      t.string :severity
      t.string :status
      t.string :impact
      t.integer :author_id
      t.integer :assignee_id

      t.timestamps
    end
  end
end
