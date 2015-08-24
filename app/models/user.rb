# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < OmniAuth::Identity::Models::ActiveRecord
  attr_accessible :name, :email, :password, :email_confirmation, :password_confirmation, :photo, :photo_file_name, :photo_content_type, :photo_file_size, :photo_updated_at, :photos_attributes, :pic, :profile_pic, :user_info_attributes, :user_info, :address_id, :address_attributes, :fb_uid, :admin
#  attr_accessor :profile_pic

  has_secure_password
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  has_many :user_groups, dependent: :destroy
  has_many :groups, :through => :user_groups
  has_many :communities, :through => :usercommunities
  has_many :usercommunities, dependent: :destroy

  has_many :events, dependent: :destroy
  has_many :event_editor_users, dependent: :destroy
  has_many :events_editor, class_name: "Event", :through => :event_editor_users

  has_many :event_invited_users, dependent: :destroy
  has_many :events_invited, class_name: "Event", :through => :event_invited_users
  has_many :events, foreign_key: "creator", dependent: :destroy

  has_many :posts, dependent: :destroy
  has_many :userlikes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authentications, dependent: :destroy
  has_many :photos, dependent: :destroy
  accepts_nested_attributes_for :photos, :allow_destroy => true

  has_one :user_info, dependent: :destroy
  accepts_nested_attributes_for :user_info, :allow_destroy => true
  
  has_many :albums, dependent: :destroy
  
  has_many :eventdetails, :dependent => :destroy
  has_many :activitydetails, :dependent => :destroy

  has_many :activitynotifications, :dependent => :destroy

  has_many :activitynotificationsettings, :dependent => :destroy

  before_save { |user| user.email = email.nil? ? nil : email.downcase }
  before_save :create_remember_token
  #before_create { generate_token(:remember_token) }

  has_many :posts, :as => :postable

  has_many :issue_ticket_actions, dependent: :destroy
  has_many :issue_trackers, foreign_key: "author_id", dependent: :destroy
  has_many :issue_trackers, foreign_key: "assignee_id", dependent: :destroy

  has_many :buysell_items, dependent: :destroy
  belongs_to  :address
  accepts_nested_attributes_for :address, :allow_destroy => true
  
 # validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }, confirmation: true
  validates :email_confirmation, presence: true, :on => :create
  validates :password, presence: true, length: { minimum: 6 }, :on => :create
  validates :password_confirmation, presence: true, :on => :create

  #validates_uniqueness_of :email, :case_sensitive => false, conditions: -> { where(valid: true) }

def send_password_reset
  generate_token(:password_reset_token)
  self.password_reset_sent_at = Time.zone.now
  save!(:validate => false)
  #UserMailer.delay.password_reset(self)
  UserMailer.password_reset(self).deliver
end

def send_token_for_user_to_join
  generate_token(:password_reset_token)
  self.password_reset_sent_at = Time.zone.now
  save!(:validate => false)
  #UserMailer.delay.invite_email(self)
  UserMailer.invite_email(self).deliver
end

def generate_token(column)
  begin
    self[column] = SecureRandom.urlsafe_base64
  end while User.exists?(column => self[column])
end

def feed
    # This is preliminary. See "Following users" for the full implementation.
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  def joined_uc
   @usercommunity = self.usercommunities.where("invitation = 'joined'") 
  end

  def is_cu_admin?(community)
    self.usercommunities.where("community_id = ? AND is_admin=?", community.id, true).exists?
  end
  
  def self.search(search, exclude_user)
    if search  
      if exclude_user.nil?
        where('name LIKE ?', "%#{search}%" )  
      else
        where('name LIKE ? AND id NOT IN (?)', "%#{search}%" , exclude_user)  
      end
    else  
      scoped  
    end  
  end 
#def photos=(attrs)
#  attrs.each { |attr| self.photos.build(:pic => attr) }
#end


  def self.create_with_omniauth(auth)
    # you should handle here different providers data
    # eg. case auth['provider'] ..
#create(name: auth['info']['name'])
    # IMPORTANT: when you're creating a user from a strategy that
    # is not identity, you need to set a password, otherwise it will fail
    # I use: user.password = rand(36**10).to_s(36)

    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
    end

  end

  def self.from_omniauth(auth)
    find_by_provider_and_uid(auth["provider"], auth["uid"]) || create_with_omniauth(auth)
  end


def apply_omniauth(omniauth)
  case omniauth['provider']
  when 'facebook'
    self.apply_facebook(omniauth)
  end
  #authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'], :token =>(omniauth['credentials']['token'] rescue nil))
end
 
def facebook
  @fb_user ||= FbGraph::User.me(self.authentications.find_by_provider('facebook').token)
end

def invited_groups
 @groups = self.user_groups.where(["invitation = ?", Uc_enum::INVITED]) 
end

protected
 
def apply_facebook(omniauth)
  if (extra = omniauth['extra']['user_hash'] rescue false)
    self.email = (extra['email'] rescue '')
    
  end
end

  private
  def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end


end
