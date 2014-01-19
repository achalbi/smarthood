class BuysellItemComment < ActiveRecord::Base
  attr_accessible :buysell_item_id, :comment_id

  belongs_to :buysell_item
  belongs_to :comment
end
