class Group < ActiveRecord::Base
  belongs_to :User
  belongs_to :photo
  attr_accessible :description, :name, :privacy, :photo_attributes, :user_tokens, :profile_pic
  accepts_nested_attributes_for :photo

  attr_reader :user_tokens
  attr_accessor :user_ids, :profile_pic
  def user_tokens=(ids)
    self.user_ids = ids.split(",")
  end

  #has_many :postables, :as => :postable
  has_many :albums, :as => :albumable

  has_many :user_groups, dependent: :destroy
  has_many :users, :through => :user_groups
  has_many :communities, :through => :user_groups

  has_many :groupposts, dependent: :destroy
  has_many :posts, :through => :groupposts

  has_many :event_invited_groups, dependent: :destroy
  has_many :events_invited, class_name: "Event", :through => :event_invited_groups
  
  has_many :event_editor_groups, dependent: :destroy
  has_many :events_editor, class_name: "Event", :through => :event_editor_groups
  has_many :eventdetails, :dependent => :destroy
  has_many :activitydetails, :dependent => :destroy

  validates :User_id, presence: true
  validates :name,  presence: true, length: { maximum: 50 }#, uniqueness: { case_sensitive: false }

  def following?(user, group)
    user.user_groups.find_by_group_id(group.id)
  end
  def follow!(user, group_id)
    user.user_groups.create!(group_id: group_id)
  end

  def follow!(user, group_id, invitation, is_admin)
    user.user_groups.create!(group_id: group_id, invitation: invitation, is_admin: is_admin)
  end

  def follow!(user, group_id, invitation, is_admin, community_id)
    if self.user_groups.where("user_id = ?  AND invitation = ?",user, Uc_enum::UNJOINED ).exists?
      self.user_groups.update_all({invitation: Uc_enum::JOINED}, {user_id: user.id})
    else
      user.user_groups.create!(group_id: group_id, invitation: invitation, is_admin: is_admin, community_id: community_id)
    end
  end

  def self.search(search, exclude_group)
    if search  
      if exclude_group.nil?
        where('name LIKE ?', "%#{search}%" )  
      else
        where('name LIKE ? AND id NOT IN (?)', "%#{search}%" , exclude_group)  
      end
    else  
      scoped  
    end  
  end 

  def joined_users
    self.user_groups.where("invitation = ?", Uc_enum::JOINED )
  end
  def is_joined?(user, group)
     group.user_groups.where("user_id = ?  AND invitation = ?",user, Uc_enum::JOINED ).exists?
  end  

  def can_admin_unjoin?(user)
     @usergroups = self.user_groups.where("is_admin = ?  AND invitation = ? ",true, Uc_enum::JOINED )
        if @usergroups.size > 1 && self.is_admin?(user)
          return true
        else
          return false
        end
  end  

  def is_admin?(current_user)
    self.user_groups.where("is_admin = ?  AND invitation = ? AND user_id = ?",true, Uc_enum::JOINED, current_user ).exists?
  end

end
	