class BuysellItemCommunity < ActiveRecord::Base
  attr_accessible :buysell_item_id, :community_id

  belongs_to :community
  belongs_to :buysell_item
end
