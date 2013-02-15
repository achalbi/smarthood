class EventInvitedGroup < ActiveRecord::Base
  attr_accessible :event_id, :group_id

  belongs_to :event
  belongs_to :group

  validates :event_id, presence: true
  validates :group_id, presence: true
end
