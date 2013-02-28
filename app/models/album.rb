class Album < ActiveRecord::Base
  attr_accessible :cover_photo_id, :description, :privacy, :title, :type, :user_id
end
