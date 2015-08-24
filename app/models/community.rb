class Community < ActiveRecord::Base
  attr_accessible :community_id, :photo_id, :photo_attributes, :name, :description, :status, :privacy, :address, :latitude, :longitude, :req_pending_cnt, :user_tokens, :comm_type, :user_id

  attr_accessor :req_pending_cnt

  attr_reader :user_tokens
  attr_accessor :user_ids
  def user_tokens=(ids)
    self.user_ids = ids.split(",")
  end
  
  geocoded_by :address   # can also be an IP address
  after_validation :geocode, :if => :address_changed?          # auto-fetch coordinates
  
  belongs_to :user
  belongs_to :photo, dependent: :destroy

  has_many :events

  has_many :communityposts, dependent: :destroy
#  has_many :posts, :as => :postable
  has_many :posts, :through => :communityposts

  has_many :buysell_item_communities, dependent: :destroy
  has_many :buysell_items, :through => :buysell_item_communities

  has_many :albums, :as => :albumable

  has_many :groups, :through => :user_groups
  has_many :user_groups, dependent: :destroy
  has_many :users, :through => :usercommunities
  has_many :usercommunities, dependent: :destroy


  accepts_nested_attributes_for :photo
  validates :user_id, presence: true
  validates :name,  presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }

  def is_active?(user, community)
    unless user.usercommunities.nil?
     @usercommunity = community.usercommunities.where("user_id = ?  AND invitation = ?",user, Uc_enum::JOINED )[0]
     unless @usercommunity.nil?
        if @usercommunity.status =="active"
          return true
        else
         return false
        end
     end
    end
  end

def is_joined?(user, community)
    unless community.usercommunities.nil?
     @usercommunity = community.usercommunities.where("user_id = ?  AND invitation = ?",user, Uc_enum::JOINED )
        if @usercommunity.size > 0
         return true
        else
          return false
        end
    end
    return false
end  

def is_invited?(user, community)
    unless community.usercommunities.nil?
     @usercommunity = community.usercommunities.where("user_id = ?  AND invitation = ?",user, Uc_enum::INVITED )
        if @usercommunity.size > 0
         return true
        else
          return false
        end
    end
    return false
end  

def is_public?(current_user)
  @public_communities = nil
  if current_user.joined_uc.collect(&:community_id).count > 0 
    @public_communities = Community.where(["id  NOT IN (?) AND privacy = ? " , current_user.joined_uc.collect(&:community_id), Privacyenum::PUBLIC])  
  else
    @public_communities = Community.where("privacy = ? ", Privacyenum::PUBLIC) 
  end 
  if @public_communities.pluck(:id).detect {|n| n==self.id}.nil?
    return false
  else
   return true
 end
end

def is_private?(current_user)
   @private_communities = nil
   if current_user.joined_uc.collect(&:community_id).count > 0 
    @private_communities = Community.where(["id  NOT IN (?) AND privacy = ?" , current_user.joined_uc.collect(&:community_id), Privacyenum::PRIVATE])   
  else
    @private_communities = Community.where("privacy = ? ", Privacyenum::PRIVATE) 
  end

  if @private_communities.pluck(:id).detect {|n| n==self.id}.nil?
    return false
  else
   return true
  end
end

  def is_admin?(user)
    self.usercommunities.where("user_id = ? AND is_admin=?", user, true).exists?
  end

  def can_admin_unjoin?(user)
    if self.is_admin?(user)
     @usercommunities = self.usercommunities.where("is_admin = ?  AND invitation = ? ",true, Uc_enum::JOINED )
        if @usercommunities.size > 1 
          return true
        else
          return false
        end
    else
      return true
    end
  end  


def can_post?(user)
  if self.protected? && self.is_active?(user, self)
   return true
  else
   return false
  end 
end

def users_count
  self.usercommunities.where("invitation = ?", Uc_enum::JOINED).count
end

  def is_requested?(user)
   @usercommunity = self.usercommunities.where("invitation = ? AND user_id = ?", Uc_enum::REQUESTED, user.id)
   if @usercommunity.count > 0
     return true
   else
     return false
   end
  end

def requested_uc
 @usercommunity = self.usercommunities.where(["invitation = ?", Uc_enum::REQUESTED]) 
end

def invited_uc
 @usercommunity = self.usercommunities.where(["invitation = ?", Uc_enum::INVITED]) 
end

def follow!(user, community_id)
  user.usercommunities.create!(community_id: community_id)
end


end
