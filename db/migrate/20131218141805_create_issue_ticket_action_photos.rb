class CreateIssueTicketActionPhotos < ActiveRecord::Migration
  def change
    create_table :issue_ticket_action_photos do |t|
      t.integer :issue_ticket_action_id
      t.integer :photo_id

      t.timestamps
    end
  end
end
