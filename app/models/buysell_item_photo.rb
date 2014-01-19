class BuysellItemPhoto < ActiveRecord::Base
  attr_accessible :buysell_item_id, :photo_id

  belongs_to :buysell_item
  belongs_to :photo
end
