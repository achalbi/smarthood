class Event < ActiveRecord::Base
  attr_accessible :description, :location, :name, :privacy, :start_date_time, :user_id

  belongs_to :User

  has_many :activities, class_name: "Activity", dependent: :destroy
  has_many :event_invited_users, dependent: :destroy
  has_many :invited_users, class_name: "User", :through => :event_invited_users, source: "user"

  has_many :event_invited_groups, dependent: :destroy
  has_many :invited_groups, class_name: "Group", :through => :event_invited_groups, source: "group"

  has_many :event_editor_users, dependent: :destroy
  has_many :editor_users, class_name: "User", :through => :event_editor_users, source: "user"

  has_many :event_editor_groups, dependent: :destroy
  has_many :editor_groups, class_name: "Group", :through => :event_editor_groups, source: "group"

	validates :name, presence: true
	validates :description, presence: true
	validates :creator, presence: true
end
