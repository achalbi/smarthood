class Activitynotificationsetting < ActiveRecord::Base
  attr_accessible :act_inv_me, :app, :community_id, :comm_mem_act, :email, :following_user_act, :new_joiners, :phone, :user_id
  belongs_to :User
end
