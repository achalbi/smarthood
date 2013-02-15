class Activity < ActiveRecord::Base
  attr_accessible :description, :event_id, :location, :name, :start_date_time

  belongs_to :event

  validates :name, presence: true
end
