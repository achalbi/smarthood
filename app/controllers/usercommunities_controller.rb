class UsercommunitiesController < ApplicationController
  before_filter :signed_in_user


  def setactive
   @usercommunity = Usercommunity.where(['status=? and user_id=?','active',current_user.id])[0]
   @usercommunity.status=""
   @usercommunity.save
   @usercommunitySel = Usercommunity.where(['community_id=? and user_id=?',params[:community_id],current_user.id])[0]
   @usercommunitySel.status="active"
   @usercommunitySel.save

  end


end