class Activity < ActiveRecord::Base
  attr_accessible :description, :event_id, :location, :title, :starts_at, :ends_at, :address, :latitude, :longitude, :privacy, :user_tokens, :group_tokens

  geocoded_by :address   # can also be an IP address
  after_validation :geocode, :if => :address_changed?          # auto-fetch coordinates
  
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
end
