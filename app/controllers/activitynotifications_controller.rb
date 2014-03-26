class ActivitynotificationsController < ApplicationController
	include ActivitynotificationsHelper

  	def new
  	end

  	def index
  		@notifications = Activitynotification.where("recepient_id = ?", current_user.id ).order("created_at DESC")
		  @notifications_settings = current_user.activitynotificationsettings.where("community_id = ?", active_community.id).first
      if @notifications_settings.blank?
        createNotificationSettings(active_community.id, current_user.id)

      # Album.update_all(privacy: 1)
      # Community.update_all(privacy: 1)
      # Event.update_all(privacy: 1)
      # Group.update_all(privacy: 1)
      end
  	end

  	def update_count
  	end

  	def mark_read
  		@notification = Activitynotification.find(params[:id])
  		@notification.is_unread=false
  		@notification.save
  	end
  
end
