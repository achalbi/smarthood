class Activity < ActiveRecord::Base
  attr_accessible :description, :event_id, :location, :title, :starts_at, :ends_at, :address, :latitude, :longitude, :privacy, :user_tokens, :group_tokens, :is_admin

  geocoded_by :address   # can also be an IP address
  after_validation :geocode, :if => :address_changed?          # auto-fetch coordinates
  #has_many :postables, :as => :postable

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

  belongs_to :event

  has_many :activityposts, dependent: :destroy
  has_many :posts, :through => :activityposts
  has_many :activitydetails, :dependent => :destroy

  has_many :albums, :as => :albumable
  
  validates :title, presence: true

  def admin?(user)
    self.activitydetails.where("user_id = ? AND is_admin=?", user, true).exists?
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
