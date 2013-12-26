class TicketAction < ActiveRecord::Base
  attr_accessible :description

  has_one :issue_ticket_action, dependent: :destroy
  validates :description,  presence: true, length: { maximum: 50 },
                    uniqueness: { case_sensitive: false }
end
