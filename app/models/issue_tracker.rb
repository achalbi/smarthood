class IssueTracker < ActiveRecord::Base
  attr_accessible :assignee_id, :author_id, :description, :impact, :module, :priority, :severity, :status, :ticket_id, :issue_type, :version, :title, :issue_ticket_actions_attributes

   belongs_to :assignee, class_name: "User"
   belongs_to :author, class_name: "User"

   has_many :issue_ticket_actions, dependent: :destroy
   accepts_nested_attributes_for :issue_ticket_actions, :allow_destroy => true

end
