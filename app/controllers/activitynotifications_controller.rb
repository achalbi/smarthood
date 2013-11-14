class ActivitynotificationsController < ApplicationController
	include ActivitynotificationsHelper

  	def new
  	end

  	def index
  		@notifications = Activitynotification.where("recepient_id = ?", current_user.id )
  		@notification = @notifications.first
  	end
  
end
