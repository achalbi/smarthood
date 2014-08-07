module ActivitynotificationsHelper

	def createNotification(user_ids ,objecttype, object, body_text, href, pic_url)
        body_html = ""
        user_ids.each do |user_id|
		    @notification = Activitynotification.new
		    @notification.sender_id = current_user.id
		    @notification.objecttype = objecttype
		    @notification.is_unread = true
		    @notification.is_hidden = false
		    @notification.body_html = body_html
		    @notification.body_text = body_text
		    @notification.pic_url = pic_url
		    @notification.href = href
		    @notification.recepient_id = user_id
		    @notification.save
        end
	        
	end


	def getNotifiableUsers(objecttype, object, objectfortype, objectfor, action)
		@users = []
		case objecttype
		  when Objecttypeenum::COMUNITY then
		    if(object.privacy==Privacyenum::PUBLIC)
		    	if action == Uc_enum::CREATED
			    	@users = current_user.followers.collect(&:id)
			    elsif action == Uc_enum::UPDATED || action == Uc_enum::JOINED
			    	@users = object.usercommunities.collect(&:user_id)
			    	@users = getActivitynotificationUserssettings(@users, objecttype, object, Privacyenum::PUBLIC).collect(&:user_id)
			    	@users = @users + current_user.followers.collect(&:id)
			    end
			elsif (object.privacy==Privacyenum::PRIVATE || object.privacy==Privacyenum::SECRET )
				if action == Uc_enum::REQUESTED
					@users = object.usercommunities.where("is_admin=?", true).collect(&:user_id)
				elsif action == Uc_enum::ACCEPTED || action == Uc_enum::INVITED
					@users = objectfor
				end
			end 
			if action == Uc_enum::ADD_MODERATOR
				@users << objectfor			
			end

		  when Objecttypeenum::EVENT then
  			@users = getEventUsers(objecttype, object, objectfortype, objectfor, action)
  			
		  when Objecttypeenum::ACTIVITY then
  			@users = getActivityUsers(objecttype, object, objectfortype, objectfor, action)

		  when Objecttypeenum::GROUP then
  			@users = getGroupUsers(objecttype, object, objectfortype, objectfor, action)


		  when Objecttypeenum::PHOTO then
		    
		  when Objecttypeenum::ALBUM then

		  	unless object.albumable_id.blank?
			  	if(object.albumable_type == Objecttypeenum::GROUP)
			  	  objectfortype == Objecttypeenum::GROUP
		          objectfor = Group.find(object.albumable_id)
	            elsif(object.albumable_type == Objecttypeenum::COMUNITY)
		          objectfortype = Objecttypeenum::COMUNITY
		          objectfor = Community.find(object.albumable_id)
		        elsif(object.albumable_type == Objecttypeenum::ACTIVITY)
		          objectfortype = Objecttypeenum::ACTIVITY
		          objectfor = Activity.find(object.albumable_id)
		          if objectfor.is_admin? 
		            objectfortype = Objecttypeenum::EVENT 
		            objectfor = objectfor.event
		          end
		        end
		  	end

			if(object.privacy == Privacyenum::PUBLIC)

		  			if(objectfortype == Objecttypeenum::EVENT)
		  				@users = getEventUsers(objectfortype, objectfor, nil, nil, action)
			  		elsif (objectfortype == Objecttypeenum::ACTIVITY)
						@users = getActivityUsers(objectfortype, objectfor, nil, nil, action)
			  		elsif (objectfortype == Objecttypeenum::GROUP)
				  	    @users = getGroupUsers(objectfortype, objectfor, nil, nil, action)
			  	    elsif (objectfortype == Objecttypeenum::COMUNITY)
				  	    @users = getCommunityUsers(objectfortype, objectfor, nil, nil, action)
				  	else
				    	@users = active_community_user_ids
				    	@users = getActivitynotificationUserssettings(@users, objecttype, object, Privacyenum::PUBLIC).collect(&:user_id)
				    	@users = @users + current_user.followers.collect(&:id)
			  		end

		    elsif (object.privacy==Privacyenum::PRIVATE)

		    end 

		  when Objecttypeenum::POST then

					if (objectfortype == Objecttypeenum::ACTIVITY)
						if objectfor.is_admin? 
				            objectfortype = Objecttypeenum::EVENT 
				            objectfor = objectfor.event
							@users = getEventUsers(objectfortype, objectfor, nil, nil, action)
						else
							@users = getActivityUsers(objectfortype, objectfor, nil, nil, action)
						end
			  		elsif (objectfortype == Objecttypeenum::GROUP)
				  	    @users = getGroupUsers(objectfortype, objectfor, nil, nil, action)
			  	    elsif (objectfortype == Objecttypeenum::GROUPS)
			  	    	objectfor.each do |group|
				  	    	@users = @users + getGroupUsers(objectfortype, group, nil, nil, action)
				  		end
				  	elsif (objectfortype == Objecttypeenum::COMUNITY)
			  	    	objectfor.each do |cu|
				  	    	@users = @users + getCUUsers(objectfortype, cu, nil, nil, action)
				  		end
				  	else
				  		@users = current_user.followers.collect(&:id)
			  		end

		  when Objecttypeenum::COMMENT then
		  	@users = objectfor.comments.collect(&:user_id)
		  when Objecttypeenum::USER then
		    @users = object.followers.collect(&:user_id)
		  else
		    @users
		end
		@users.uniq
		unless @users.detect {|n| n == current_user.id}.nil?
		#	@users=@users.reject {|n| n == current_user.id}
		end
		body_text = build_body_text(objecttype, object, objectfortype, objectfor, action)
		href = build_href(objecttype, object, objectfortype, objectfor, action)
		pic_url = build_pic_url(objecttype, object, objectfortype, objectfor, action)
		if @users.count > 0
			createNotification(@users ,objecttype, object, body_text, href, pic_url)
		end
	end

	def getActivitynotificationUserssettings(users, objecttype, object, activityLevel )
		unless(objecttype == Objecttypeenum::COMUNITY)
			object = active_community
		end
		if(activityLevel==Privacyenum::PUBLIC)
			@act_notif_sett = Activitynotificationsetting.where("user_id IN (?) AND community_id = ? AND cu_mem_act = 'all'",users, object.id ) 
		elsif (activityLevel==Privacyenum::PRIVATE)
			@act_notif_sett = Activitynotificationsetting.where("user_id IN (?) AND community_id = ? AND act_inv_me = 'all'",users, object.id ) 		
		end
	end

	def createNotificationSettings(cu_id, user_id)
        @notifications_settings = Activitynotificationsetting.new
        @notifications_settings.user_id = user_id
        @notifications_settings.community_id = cu_id
        @notifications_settings.app = true
        @notifications_settings.email = true
        @notifications_settings.phone = true
        @notifications_settings.cu_mem_act = 'all'
        @notifications_settings.act_inv_me = 'all'
        @notifications_settings.following_user_act = 'all'
        @notifications_settings.new_joiners = 'all'
        @notifications_settings.save
		
	end

	def deleteNotificationSettings(cu_id, user_id)
		Activitynotificationsetting.where("community_id = ? AND user_id = ?", cu_id, user_id).first.destroy
	end

	def build_body_text(objecttype, object, objectfortype, objectfor, action)
		body_text = ""
		if objectfortype == Objecttypeenum::USER_IDS
			if objectfor.count == 1
				objectfor = User.where("id IN (?)", objectfor).first
			end
		end
		case objecttype
		  when Objecttypeenum::COMUNITY then
		  		if action == Notificationtypeenum::CREATED
		  			body_text = "The ComUnity '" + object.name + "' was created by "+ current_user.name
		  		elsif action == Notificationtypeenum::UPDATED
		  			body_text = "The ComUnity '" + object.name + "' was updated by "+ current_user.name
		  		elsif action == Notificationtypeenum::JOINED
		  			body_text = objectfor.name + " has joined the ComUnity '" + object.name + "'."
		  		elsif action == Notificationtypeenum::REQUESTED
		  			body_text = objectfor.name + " has requested to join the ComUnity '" + object.name  + "'."
		  		elsif action == Notificationtypeenum::ACCEPTED
		  			body_text = "The request to join the ComUnity '" + object.name  + "' has been accepted."
		  		elsif action == Uc_enum::INVITED
		  			body_text = "The moderator of the ComUnity '" + object.name  + "' has requested to join the community."
		  		elsif action == Uc_enum::ADD_MODERATOR
		  			body_text = "You now moderator for the ComUnity '" + object.name  + "'."
		  		end
		  when Objecttypeenum::EVENT then
		  		if action == Notificationtypeenum::CREATED
		  			body_text = "The Event '" + object.title + "' was created by "+ current_user.name
		  		elsif action == Notificationtypeenum::UPDATED
		  			body_text = "The Event '" + object.title + "' was updated by "+ current_user.name
		  		end
		  when Objecttypeenum::ACTIVITY then
		   		if action == Notificationtypeenum::CREATED
		  			body_text = "The Activity '" + object.title + "' was created by "+ current_user.name
		  		elsif action == Notificationtypeenum::UPDATED
		  			body_text = "The Activity '" + object.title + "' was updated by "+ current_user.name
		  		end
		  when Objecttypeenum::PHOTO then
		  when Objecttypeenum::ALBUM then
		  		if action == Notificationtypeenum::CREATED
		  			if objectfortype.nil?
			  			body_text = "The Album '" + object.title + "' was added by "+ current_user.name 
		  			else
			  			body_text = "The Album '" + object.title + "' was added to " + objectfortype + ": '" + objectfor.title + "' by "+ current_user.name 
		  			end
		  		elsif action == Notificationtypeenum::UPDATED
		  			body_text = "The Album '" + object.title + "' was updated by "+ current_user.name
		  		end
		  when Objecttypeenum::GROUP then
		  		if action == Notificationtypeenum::CREATED
		  			body_text = "The Group '" + object.name + "' was created by "+ current_user.name 
		  		elsif action == Notificationtypeenum::UPDATED
		  			body_text = "The Group '" + object.name + "' was updated by "+ current_user.name
		  		end
		  when Objecttypeenum::POST then
		  	if (objectfortype == Objecttypeenum::GROUP)
		  		body_text = current_user.name + " has posted on the "+ objectfortype + ": '" + objectfor.name + "'."
		  	else
		  		body_text = current_user.name + " has posted."
		  	end

		  when Objecttypeenum::COMMENT then
		  		body_text = current_user.name + " has commented on the post."
		  when Objecttypeenum::USER then
		  else
		end	
	end

	def build_href(objecttype, object, objectfortype, objectfor, action)
        href = ""
        case objecttype
		  when Objecttypeenum::COMUNITY then
		  		href = "/communities/"+ object.id.to_s	
		  when Objecttypeenum::EVENT then
		  		href = "/events/"+ object.id.to_s
		  when Objecttypeenum::ACTIVITY then
		  		href = "/activities/"+ object.id.to_s
		  when Objecttypeenum::PHOTO then
		  when Objecttypeenum::ALBUM then
		  		href = "/albums/"+ object.id.to_s
		  when Objecttypeenum::GROUP then
		  		href = "/groups/"+ object.id.to_s
		  when Objecttypeenum::POST then
		  		href = "/posts/"+ object.id.to_s
		  when Objecttypeenum::COMMENT then
		  		href = "/posts/"+ objectfor.id.to_s
		  when Objecttypeenum::USER then
		  else
		end	
	end

	def build_pic_url(objecttype, object, objectfortype, objectfor, action)
        pic_url = ""
        case objecttype
		  when Objecttypeenum::COMUNITY then
		  		pic_url = object.photo.pic_url(:smaller_mid)
		  when Objecttypeenum::EVENT then
		  		pic_url = object.photo.pic_url(:smaller_mid)
		  when Objecttypeenum::ACTIVITY then
		  		pic_url = object.event.photo.pic_url(:smaller_mid)
		  when Objecttypeenum::PHOTO then
		  when Objecttypeenum::ALBUM then
		  		pic_url = object.photos[0].pic_url(:smaller_mid)
		  when Objecttypeenum::GROUP then
		  		pic_url = object.photo.pic_url(:smaller_mid)
		  when Objecttypeenum::POST then
		  		pic_url = gravatar_for_url(current_user, size: 75)
		  when Objecttypeenum::COMMENT then
		  		pic_url = gravatar_for_url(current_user, size: 75)
		  when Objecttypeenum::USER then
		  else
		end	
	end

	def getCUUsers(objecttype, object, objectfortype, objectfor, action)
		@users = []
		@users = object.usercommunities.collect(&:user_id)
		@users = getActivitynotificationUserssettings(@users, objecttype, object, Privacyenum::PUBLIC).collect(&:user_id)
		@users = @users + current_user.followers.collect(&:id)
	end

	def getEventUsers(objecttype, object, objectfortype, objectfor, action)
		@users = []
			    if(object.privacy==Privacyenum::PUBLIC)
			    	@users = active_community_user_ids
			    	@users = getActivitynotificationUserssettings(@users, objecttype, object, Privacyenum::PUBLIC).collect(&:user_id)
			    	@users = @users + current_user.followers.collect(&:id)
			   	elsif (object.privacy==Privacyenum::MEMBERS)
			    	@users = active_community_user_ids
			    elsif (object.privacy==Privacyenum::PRIVATE)
			    	@users = object.eventdetails.collect(&:user_id)
			    end 
			    @users	
			    	
	end

	def getActivityUsers(objecttype, object, objectfortype, objectfor, action)
		@users = []
		  	objectfor = object.event
		    if(objectfor.privacy==Privacyenum::PUBLIC)
		  		if (object.privacy==Privacyenum::PUBLIC)
		  			@users = objectfor.eventdetails.collect(&:user_id)
		  			@users = getActivitynotificationUserssettings(@users, objecttype, object, Privacyenum::PUBLIC).collect(&:user_id)
			    	@users = @users + current_user.followers.collect(&:id)
			    else(object.privacy==Privacyenum::PRIVATE)
			    	@users = object.activitydetails.collect(&:user_id)
					@users = getActivitynotificationUserssettings(@users, objecttype, object, Privacyenum::PRIVATE).collect(&:user_id)
			    end  
			elsif objectfor.privacy==Privacyenum::MEMBERS
				if (object.privacy==Privacyenum::PUBLIC)
		  			@users = objectfor.eventdetails.collect(&:user_id)
		  			@users = getActivitynotificationUserssettings(@users, objecttype, object, Privacyenum::PUBLIC).collect(&:user_id)
			    else(object.privacy==Privacyenum::PRIVATE)
			    	@users = object.activitydetails.collect(&:user_id)
					@users = getActivitynotificationUserssettings(@users, objecttype, object, Privacyenum::PRIVATE).collect(&:user_id)
			    end
			elsif (objectfor.privacy==Privacyenum::PRIVATE)
		  		if (object.privacy==Privacyenum::PUBLIC)
		  			@users = objectfor.eventdetails.collect(&:user_id)
			    else(object.privacy==Privacyenum::PRIVATE)
			    	@users = object.activitydetails.collect(&:user_id)
			    end 
			end 
			@users
	end

	def getGroupUsers(objecttype, object, objectfortype, objectfor, action)
		@users = []
		if action == Uc_enum::INVITED
			@users = User.where("id IN (?)", objectfor)
		else
		  	    if(object.privacy==Privacyenum::PUBLIC)
		  	    	@users = community_user_ids(object.community_id) #all community members
			    	@users = getActivitynotificationUserssettings(@users, objecttype, object, Privacyenum::PUBLIC).collect(&:user_id)
			    	@users = @users + current_user.followers.collect(&:id)
		  	    elsif(object.privacy==Privacyenum::MEMBERS)
			    	@users = community_user_ids(object.community_id)
			    	@users = getActivitynotificationUserssettings(@users, objecttype, object, Privacyenum::PUBLIC).collect(&:user_id)
			    	@users = @users + current_user.followers.collect(&:id)
			    elsif (object.privacy==Privacyenum::PRIVATE)
				    @users = object.user_groups.collect(&:user_id)
			    end 
		end
		@users
	end
	
	def getCommunityUsers(objecttype, object, objectfortype, objectfor, action)
		@users = []
		if action == Uc_enum::INVITED
			@users = User.where("id IN (?)", objectfor)
		else
		  	    if(object.privacy==Privacyenum::PUBLIC)
		  	    	@users = community_user_ids(object.id) #all community members
			    	@users = getActivitynotificationUserssettings(@users, objecttype, object, Privacyenum::PUBLIC).collect(&:user_id)
			    	@users = @users + current_user.followers.collect(&:id)
		  	    elsif(object.privacy==Privacyenum::MEMBERS)
			    	@users = community_user_ids(object.id)
			    	@users = getActivitynotificationUserssettings(@users, objecttype, object, Privacyenum::PUBLIC).collect(&:user_id)
			    	@users = @users + current_user.followers.collect(&:id)
			    elsif (object.privacy==Privacyenum::PRIVATE)
				    @users = object.users.collect(&:id)
			    end 
		end
		@users
	end	
end
