class Group < ActiveRecord::Base
  belongs_to :User
  attr_accessible :description, :name, :privacy

  has_many :user_groups, dependent: :destroy
  has_many :users, :through => :user_groups

  has_many :groupposts, dependent: :destroy
  has_many :posts, :through => :groupposts

  has_many :event_invited_groups, dependent: :destroy
  has_many :events_invited, class_name: "Event", :through => :event_invited_groups
  
  has_many :event_editor_groups, dependent: :destroy
  has_many :events_editor, class_name: "Event", :through => :event_editor_groups
  
  validates :User_id, presence: true

  def following?(user, group)
    user.user_groups.find_by_group_id(group.id)
  end
  def follow!(user, group_id)
    user.user_groups.create!(group_id: group_id)
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

end
	