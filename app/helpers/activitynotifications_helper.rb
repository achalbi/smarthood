module ActivitynotificationsHelper

	def createNotification(user_id ,objecttype, object)
        body_html = ""
        body_text = "The album '" + object.title + "' was created by "+ current_user.name
        href = "/albums/"+ object.id.to_s
        pic_url = object.photos[0].pic_url(:smaller_mid)

	    @notification = Activitynotification.new
	    @notification.sender_id = current_user.id
	    @notification.objecttype = objecttype
	    @notification.Activitynotificationtype = notificationtype
	    @notification.is_unread = false
	    @notification.is_hidden = false
	    @notification.body_html = body_html
	    @notification.body_text = body_text
	    @notification.pic_url = pic_url
	    @notification.href = href

	    @notification.recepient_id = user_id
	    
	    @notification.save
	        
	end


	def getNotifiableUsers(objecttype, object, objectfortype, objectfor)
		@users = []
		case objecttype
		  when Objecttypeenum::COMUNITY then
		    @users = active_community_user_ids

		  when Objecttypeenum::EVENT then
			    if(object.privacy==Privacyenum::PUBLIC || object.privacy==Privacyenum::MEMBERS)
			    	@users = active_community_user_ids
			    elsif (object.privacy==Privacyenum::PRIVATE)
			    	@users = object.eventdetails.collect(&:user_id)
			    end   		

		  when Objecttypeenum::ACTIVITY then
		  		if (object.privacy==Privacyenum::MEMBERS)
		  			@users = object.event.eventdetails.collect(&:user_id)
			    else(object.privacy==Privacyenum::CUSTOM)
			    	@users = object.activitydetails.collect(&:user_id)
			    end  

		  when Objecttypeenum::GROUP then
			    @users = object.user_groups.collect(&:user_id)

		  when Objecttypeenum::PHOTO then
		    
		  when Objecttypeenum::ALBUM then
			if(object.privacy==Privacyenum::PUBLIC)

		  			if(objectfortype == Objecttypeenum::EVENT)
		    
						if(objectfor.privacy==Privacyenum::PUBLIC || object.privacy==Privacyenum::MEMBERS)
					    	@users = active_community_user_ids
					    elsif (objectfor.privacy==Privacyenum::PRIVATE)
					    	@users = object.eventdetails.collect(&:user_id)
					    end  

			  		elsif (objectfortype == Objecttypeenum::ACTIVITY)

					  		if (object.privacy==Privacyenum::MEMBERS)
					  			@users = object.event.eventdetails.collect(&:user_id)
						    else(object.privacy==Privacyenum::CUSTOM)
						    	@users = object.activitydetails.collect(&:user_id)
						    end 
			  				
			  		end
		    elsif (object.privacy==Privacyenum::PRIVATE)

		    end 
		  when Objecttypeenum::POST then
		   			if(objectfortype == Objecttypeenum::EVENT)
						if(objectfor.privacy==Privacyenum::PUBLIC || object.privacy==Privacyenum::MEMBERS)
					    	@users = active_community_user_ids
					    elsif (objectfor.privacy==Privacyenum::PRIVATE)
					    	@users = object.eventdetails.collect(&:user_id)
					    end  
			  		elsif (objectfortype == Objecttypeenum::ACTIVITY)
					  		if (object.privacy==Privacyenum::MEMBERS)
					  			@users = object.event.eventdetails.collect(&:user_id)
						    else(object.privacy==Privacyenum::CUSTOM)
						    	@users = object.activitydetails.collect(&:user_id)
						    end 
					else
			  			@users = active_community_user_ids
			  		end
		  when Objecttypeenum::COMMENT then
		  	@users = objectfor.comments.collect(&:user_id)

		  	unless object.user_id == current_user.id
		  		@users << object.user_id
		  	end

		  when Objecttypeenum::USER then
		    @users = object.followed_users.collect(&:user_id)
		  else
		    @users
		end

	end

	def getActivitynotificationUserssettings(users)

		@act_notif_sett = Activitynotificationsettings.where("user_id IN (?) AND community_id = ? ",users, active_community.id ) 

	end

end
