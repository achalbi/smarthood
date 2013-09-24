class Community < ActiveRecord::Base
  attr_accessible :community_id, :photo_id, :photo_attributes, :name, :description, :status, :privacy, :address, :latitude, :longitude

  geocoded_by :address   # can also be an IP address
  after_validation :geocode, :if => :address_changed?          # auto-fetch coordinates
  
  belongs_to :user
  belongs_to :photo

  has_many :groups, :through => :user_groups
  has_many :user_groups, dependent: :destroy
  has_many :users, :through => :usercommunities
  has_many :usercommunities, dependent: :destroy

  accepts_nested_attributes_for :photo
  validates :user_id, presence: true
  validates :name,  presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }

  def is_active?(user, community)
    unless user.usercommunities.nil?
     @usercommunity = community.usercommunities.where("user_id = ?  AND invitation = 'joined'",user )[0]
     unless @usercommunity.nil?
      if @usercommunity.status =="active"
        return false
      else
       return true
     end
   end
 end
end

def is_public?(current_user)
  @public_communities = nil
  if current_user.joined_uc.collect(&:community_id).count > 0 
    @public_communities = Community.where(["id  NOT IN (?) AND privacy ='public'" , current_user.joined_uc.collect(&:community_id)])  
  else
    @public_communities = Community.where("privacy ='public'") 
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
    @private_communities = Community.where(["id  NOT IN (?) AND privacy = 'private'" , current_user.joined_uc.collect(&:community_id)])   
  else
    @private_communities = Community.where("privacy ='private'") 
  end

  if @private_communities.pluck(:id).detect {|n| n==self.id}.nil?
    return false
  else
   return true
  end
end


  def is_requested?(current_user)
   @usercommunity = self.usercommunities.where("invitation = 'requested' AND user_id = ?", current_user.id)
   if @usercommunity.count > 0
     return true
   else
     return false
   end
  end

def requested_uc
 @usercommunity = self.usercommunities.where(["invitation = 'requested'"]) 
end

def follow!(user, community_id)
  user.usercommunities.create!(community_id: community_id)
end
end
