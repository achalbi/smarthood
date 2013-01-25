class Group < ActiveRecord::Base
  belongs_to :User
  attr_accessible :description, :name, :privacy

  has_many :user_groups, dependent: :destroy
  has_many :users, :through => :user_groups
  validates :User_id, presence: true

  def following?(user, group)
    user.user_groups.find_by_group_id(group.id)
  end
  def follow!(user, group_id)
    user.user_groups.create!(group_id: group_id)
  end
end
	