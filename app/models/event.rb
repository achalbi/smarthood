class Event < ActiveRecord::Base
  attr_accessible :all_day, :description, :location, :title, :privacy, :starts_at, :ends_at, :user_id

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

	validates :title, presence: true
	validates :description, presence: true
	validates :creator, presence: true

  scope :between, lambda {|starts_at, ends_at|
    {:conditions => ["? < starts_at < ?", Event.format_date(starts_at), Event.format_date(ends_at)] }
  }

  # need to override the json view to return what full_calendar is expecting.
  # http://arshaw.com/fullcalendar/docs/event_data/Event_Object/
  def as_json(options = {})
    {
      :id => self.id,
      :title => self.title,
      :description => self.description || "",
      :start => starts_at.rfc822,
      :end => ends_at.rfc822,
      :allDay => self.all_day,
      :recurring => false,
      :url => Rails.application.routes.url_helpers.event_path(id),
      #:color => "red"
    }

  end

  def self.format_date(date_time)
    Time.at(date_time.to_i).to_formatted_s(:db)
  end

end
