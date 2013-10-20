class UserGroup < ActiveRecord::Base
  attr_accessible :group_id, :user_id, :invitation, :is_admin

  belongs_to :group
  belongs_to :user

  validates :group_id, presence: true
  validates :user_id, presence: true



  def unfollow!(user, id)
    user.user_groups.find(id).destroy
  end
end
