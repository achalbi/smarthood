class IssueTicketActionPhoto < ActiveRecord::Base
  attr_accessible :issue_ticket_action_id, :photo_id

  belongs_to :issue_ticket_action
  belongs_to :photo

  validates :issue_ticket_action_id, presence: true
  validates :photo_id, presence: true

end
