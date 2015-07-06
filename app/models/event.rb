class Event < ActiveRecord::Base
  attr_accessible :all_day, :description, :location, :title, :privacy, :starts_at, :ends_at, :user_id, :address, :latitude, :longitude,:photo_id, :photo_attributes, :user_tokens, :eventdetails_attributes, :group_tokens, :GuestsCanInvite

  geocoded_by :address   # can also be an IP address
  after_validation :geocode, :if => :address_changed?          # auto-fetch coordinates
  has_many :eventdetails, :dependent => :destroy
  belongs_to :User
  belongs_to :photo
  accepts_nested_attributes_for :photo
  accepts_nested_attributes_for :eventdetails
  has_many :posts, :as => :postable

  attr_reader :user_tokens
  attr_accessor :user_ids
  def user_tokens=(ids)
    self.user_ids = ids.split(",")
  end
  attr_reader :group_tokens
  attr_accessor :group_ids
  def group_tokens=(ids)
    self.group_ids = ids.split(",")
  end
  has_many :activities, class_name: "Activity", dependent: :destroy
  has_many :event_invited_users, dependent: :destroy
  has_many :invited_users, class_name: "User", :through => :event_invited_users, source: "user"

  has_many :event_invited_groups, dependent: :destroy
  has_many :invited_groups, class_name: "Group", :through => :event_invited_groups, source: "group"

  has_many :event_editor_users, dependent: :destroy
  has_many :editor_users, class_name: "User", :through => :event_editor_users, source: "user"

  has_many :event_editor_groups, dependent: :destroy
  has_many :editor_groups, class_name: "Group", :through => :event_editor_groups, source: "group"

  has_many :activityposts, dependent: :destroy
  has_many :posts, :through => :activityposts
	
	#validates :description, presence: true
  validates :creator, presence: true
  validates :title,  presence: true, length: { maximum: 50 } #, uniqueness: { case_sensitive: false }

  scope :between, lambda {|starts_at, ends_at|
    {:conditions => ["starts_at between ? and ?", Event.format_date(starts_at), Event.format_date(ends_at)] }
  }

  # need to override the json view to return what full_calendar is expecting.
  # http://arshaw.com/fullcalendar/docs/event_data/Event_Object/
  def as_json(options = {})
    {
      :id => self.id,
      :title => self.title,
      :description => self.description || "",
      :start => unless starts_at.blank? then  starts_at.rfc822 else "" end,
      :end => unless ends_at.blank? then  ends_at.rfc822 else "" end,
      :allDay => self.all_day,
      :recurring => false,
      #:url => Rails.application.routes.url_helpers.event_path(id),
      #:color => "red"
    }
  end

  def self.format_date(date_time)
    Time.zone.at(date_time.to_i).to_formatted_s(:db)
  end

  def self.search(search)
      search.present? and all(:conditions => [ 'name LIKE ?', "%#{search.strip}%" ])
  end

  def is_admin?(user)
    self.eventdetails.where("user_id = ? AND is_admin=?", user, true).exists?
  end

  def responded?(user)
    self.eventdetails.where("user_id = ? AND status!=?", user, "invited").exists?
  end
  
   def invited?(user)
    self.eventdetails.where("user_id = ? AND status=?", user, "invited").exists?
  end
 
  def time_str(event)
    if self.starts_at.to_date == self.ends_at.to_date
      if self.starts_at.strftime("%I:%M%p") == "12:00AM"
         if event.starts_at.to_date == Time.zone.now.to_date 
              return "Today"
         elsif event.starts_at.to_date == Time.zone.now.to_date - 1.day
              return "Yesterday"
         else
              return event.starts_at.strftime("%A, %B %d, %Y")
         end
      else
        if event.starts_at.to_date == Time.zone.now.to_date 
              return "Today @ "+ event.starts_at.strftime("%I:%M%p")
         elsif event.starts_at.to_date == Time.zone.now.to_date - 1.day
              return "Yesterday @ " + event.starts_at.strftime("%I:%M%p")
         else
          if self.starts_at.strftime("%I:%M%p") == self.ends_at.strftime("%I:%M%p")
            return event.starts_at.strftime("%A, %B %d, %Y @ %I:%M%p ")
          else
            return event.starts_at.strftime("%A, %B %d, %Y @ %I:%M%p ") + " - " + event.ends_at.strftime("%I:%M%p")
          end
         end
      end
    
    else
         if event.starts_at.to_date == Time.zone.now.to_date 
              return "Today @ " + event.starts_at.strftime("%I:%M%p") + " - " + event.ends_at.strftime("%A, %B %d, %Y @ %I:%M%p ")
         elsif event.starts_at.to_date == Time.zone.now.to_date - 1.day
              return "Yesterday @ " + event.starts_at.strftime("%I:%M%p ") + " - " + event.ends_at.strftime("%A, %B %d, %Y @ %I:%M%p ")
         else
              return event.starts_at.strftime("%A, %B %d, %Y @ %I:%M%p ") + " - " + event.ends_at.strftime("%A, %B %d, %Y @ %I:%M%p ")
         end
    end
  end
  
end
