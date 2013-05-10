class Share < ActiveRecord::Base
  attr_accessible :album_id, :creation_date, :share_id, :type
end
