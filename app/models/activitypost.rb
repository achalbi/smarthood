class Activitypost < ActiveRecord::Base
  attr_accessible :activity_id, :post_id, :event_id

  belongs_to :activity
  belongs_to :post
  belongs_to :event

  validates :activity_id, presence: true
  validates :post_id, presence: true
end
