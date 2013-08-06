class Eventdetail < ActiveRecord::Base
  attr_accessible :event_id, :group_id, :is_admin, :status, :user_id

  belongs_to :event
  belongs_to :group
  belongs_to :user


end
