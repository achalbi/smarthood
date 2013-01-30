class UserGroup < ActiveRecord::Base
  attr_accessible :group_id, :user_id

  belongs_to :group
  belongs_to :user

  validates :group_id, presence: true
  validates :user_id, presence: true

  has_many :groupposts, dependent: :destroy
  has_many :posts, :through => :groupposts

  def unfollow!(user, id)
    user.user_groups.find(id).destroy
  end
end
