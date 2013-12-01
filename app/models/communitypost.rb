class Communitypost < ActiveRecord::Base
  attr_accessible :community_id, :post_id

  belongs_to :community
  belongs_to :post

  validates :community_id, presence: true
  validates :post_id, presence: true

  default_scope order: 'communityposts.created_at DESC'

end
