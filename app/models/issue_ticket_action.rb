class IssueTicketAction < ActiveRecord::Base
  attr_accessible :comment, :issue_tracker_id, :ticket_action_id, :user_id, :ticket_action_attributes, :photos

  belongs_to :user
  belongs_to :issue_tracker
  belongs_to :ticket_action
  accepts_nested_attributes_for :ticket_action, :allow_destroy => true


  has_many :issue_ticket_action_photos, dependent: :destroy
  has_many :photos, :through => :issue_ticket_action_photos

end
