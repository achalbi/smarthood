class Activitydetail < ActiveRecord::Base
  attr_accessible :activity_id, :group_id, :user_id

  belongs_to :activity
  belongs_to :group
  belongs_to :user

end
