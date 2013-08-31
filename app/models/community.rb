class Community < ActiveRecord::Base
  attr_accessible :community_id, :photo_id, :photo_attributes, :name, :description, :status, :privacy

    belongs_to :user
    belongs_to :photo
    
    has_many :groups, :through => :user_groups
    has_many :user_groups, dependent: :destroy
    has_many :users, :through => :usercommunities
    has_many :usercommunities, dependent: :destroy

    accepts_nested_attributes_for :photo
	  validates :user_id, presence: true
    validates :name,  presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }

  def following?(user, community)
   @usercommunity = user.usercommunities.find_by_community_id(community.id)
    unless @usercommunity.nil?
      if @usercommunity.status =="active"
        return false
      else
       return true
      end
    end
    
  end

  def follow!(user, community_id)
    user.usercommunities.create!(community_id: community_id)
  end
end
