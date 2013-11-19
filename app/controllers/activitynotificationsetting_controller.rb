class ActivitynotificationsettingController < ApplicationController

  def update
  		@activitynotificationsetting = Activitynotificationsetting.find(params[:id])
  		@activitynotificationsetting.update_attributes(params[:activitynotificationsetting])
  end
end
