class Usercommunity < ActiveRecord::Base
  attr_accessible :community_id, :status, :user_id, :is_admin

  belongs_to :community
  belongs_to :user

  validates :community_id, presence: true
  validates :user_id, presence: true

end
