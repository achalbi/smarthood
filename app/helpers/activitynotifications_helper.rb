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
		if(objectfortype == Objecttypeenum::GROUP)
          objectfor = Group.find(albumable_id)
        elsif(objectfortype == Objecttypeenum::ACTIVITY)
          objectfor = Activity.find(albumable_id)
          if @activity.is_admin? 
            objectfortype = Objecttypeenum::EVENT 
            objectfor = objectfor.event
          end
        end
		case objecttype
		  when Objecttypeenum::COMUNITY then
		    if(object.privacy==Privacyenum::PUBLIC)
		    	if action == Uc_enum::CREATED
			    	@users = current_user.followers.collect(&:id)
			    elsif action == Uc_enum::UPDATED || action == Uc_enum::JOINED
			    	@users = object.usercommunities.collect(&:user_id)
			    	@users = getActivitynotificationUserssettings(@users, objecttype, object, Privacyenum::PUBLIC).collect(&:user_id)
			    	@users = @users + current_user.followers.collect(&:id)
			    	#debugger
			    end
			elsif (object.privacy==Privacyenum::PRIVATE || object.privacy==Privacyenum::SECRET )
				if action == Uc_enum::REQUESTED
					@users = object.usercommunities.where("is_admin=?", true).collect(&:user_id)
				elsif action == Uc_enum::ACCEPTED || action == Uc_enum::INVITED
					@users = objectfor
				end
			end 
			if action == Uc_enum::ADD_MODERATOR
				@users = objectfor			
			end

		  when Objecttypeenum::EVENT then
			    if(object.privacy==Privacyenum::PUBLIC || object.privacy==Privacyenum::MEMBERS)
			    	@users = active_community_user_ids
			    	@users = getActivitynotificationUserssettings(@users, objecttype, object, Privacyenum::PUBLIC).collect(&:user_id)
			    	@users = @users + current_user.followers.collect(&:id)
			    elsif (object.privacy==Privacyenum::PRIVATE)
			    	@users = object.eventdetails.collect(&:user_id)
			    end   		

		  when Objecttypeenum::ACTIVITY then
		  	objectfor = object.event
		    if(objectfor.privacy==Privacyenum::PUBLIC || objectfor.privacy==Privacyenum::MEMBERS)
		  		if (object.privacy==Privacyenum::PUBLIC)
		  			@users = objectfor.eventdetails.collect(&:user_id)
		  			@users = getActivitynotificationUserssettings(@users, objecttype, object, Privacyenum::PUBLIC).collect(&:user_id)
			    	@users = @users + current_user.followers.collect(&:id)
			    else(object.privacy==Privacyenum::PRIVATE)
			    	@users = object.activitydetails.collect(&:user_id)
					@users = getActivitynotificationUserssettings(@users, objecttype, object, Privacyenum::PUBLIC).collect(&:user_id)
			    	@users = @users + current_user.followers.collect(&:id)
			    end  
			elsif (objectfor.privacy==Privacyenum::PRIVATE)
		  		if (object.privacy==Privacyenum::PUBLIC)
		  			@users = objectfor.eventdetails.collect(&:user_id)
			    else(object.privacy==Privacyenum::PRIVATE)
			    	@users = object.activitydetails.collect(&:user_id)
			    end 
			end   		


		  when Objecttypeenum::GROUP then
		  	    if(object.privacy==Privacyenum::PUBLIC)
			    	@users = active_community_user_ids
			    	@users = getActivitynotificationUserssettings(@users, objecttype, object, Privacyenum::PUBLIC).collect(&:user_id)
			    	@users = @users + current_user.followers.collect(&:id)
			    elsif (object.privacy==Privacyenum::PRIVATE)
				    @users = object.user_groups.collect(&:user_id)
			    end 

		  when Objecttypeenum::PHOTO then
		    
		  when Objecttypeenum::ALBUM then
			if(object.privacy==Privacyenum::PUBLIC)

		  			if(objectfortype == Objecttypeenum::EVENT)
		    
						if(objectfor.privacy==Privacyenum::PUBLIC || object.privacy==Privacyenum::MEMBERS)
					    	@users = active_community_user_ids
					    	@users = getActivitynotificationUserssettings(@users, objecttype, object, Privacyenum::PUBLIC).collect(&:user_id)
					    	@users = @users + current_user.followers.collect(&:id)
					    elsif (objectfor.privacy==Privacyenum::PRIVATE)
					    	@users = objectfor.eventdetails.collect(&:user_id)
					    end  

			  		elsif (objectfortype == Objecttypeenum::GROUP)
				  	    if(object.privacy==Privacyenum::PUBLIC)
					    	@users = active_community_user_ids
					    	@users = getActivitynotificationUserssettings(@users, objecttype, object, Privacyenum::PUBLIC).collect(&:user_id)
					    	@users = @users + current_user.followers.collect(&:id)
					    elsif (object.privacy==Privacyenum::PRIVATE)
						    @users = object.user_groups.collect(&:user_id)
					    end 

			  		elsif (objectfortype == Objecttypeenum::ACTIVITY)
							    if(objectfor.event.privacy==Privacyenum::PUBLIC || objectfor.event.privacy==Privacyenum::MEMBERS)
							  		if (objectfor.privacy==Privacyenum::PUBLIC)
							  			@users = active_community_user_ids
							  			@users = getActivitynotificationUserssettings(@users, objecttype, object, Privacyenum::PUBLIC).collect(&:user_id)
								    	@users = @users + current_user.followers.collect(&:id)
								    else(objectfor.privacy==Privacyenum::PRIVATE)
								    	@users = objectfor.activitydetails.collect(&:user_id)
										@users = getActivitynotificationUserssettings(@users, objecttype, object, Privacyenum::PUBLIC).collect(&:user_id)
								    	@users = @users + current_user.followers.collect(&:id)
								    end  
								elsif (objectfor.event.privacy==Privacyenum::PRIVATE)
							  		if (objectfor.privacy==Privacyenum::PUBLIC)
							  			@users = objectfor.event.eventdetails.collect(&:user_id)
								    else(objectfor.privacy==Privacyenum::PRIVATE)
								    	@users = objectfor.activitydetails.collect(&:user_id)
								    end 
								end  			  				
			  		end
		    elsif (object.privacy==Privacyenum::PRIVATE)

		    end 
		  when Objecttypeenum::POST then
		   			if(objectfortype == Objecttypeenum::EVENT)
						if(objectfor.privacy==Privacyenum::PUBLIC || object.privacy==Privacyenum::MEMBERS)
					    	@users = active_community_user_ids
					    	@users = getActivitynotificationUserssettings(@users, objecttype, object, Privacyenum::PUBLIC).collect(&:user_id)
					    	@users = @users + current_user.followers.collect(&:id)
					    elsif (objectfor.privacy==Privacyenum::PRIVATE)
					    	@users = objectfor.eventdetails.collect(&:user_id)
					    end  
 					
			  		elsif (objectfortype == Objecttypeenum::GROUP)
				  	    if(object.privacy==Privacyenum::PUBLIC)
					    	@users = active_community_user_ids
					    	@users = getActivitynotificationUserssettings(@users, objecttype, object, Privacyenum::PUBLIC).collect(&:user_id)
					    	@users = @users + current_user.followers.collect(&:id)
					    elsif (object.privacy==Privacyenum::PRIVATE)
						    @users = object.user_groups.collect(&:user_id)
					    end 

			  		elsif (objectfortype == Objecttypeenum::ACTIVITY)

			 				    if(objectfor.event.privacy==Privacyenum::PUBLIC || objectfor.event.privacy==Privacyenum::MEMBERS)
							  		if (objectfor.privacy==Privacyenum::PUBLIC)
							  			@users = objectfor.event.eventdetails.collect(&:user_id)
							  			@users = getActivitynotificationUserssettings(@users, objecttype, object, Privacyenum::PUBLIC).collect(&:user_id)
								    	@users = @users + current_user.followers.collect(&:id)
								    else(objectfor.privacy==Privacyenum::PRIVATE)
								    	@users = objectfor.activitydetails.collect(&:user_id)
										@users = getActivitynotificationUserssettings(@users, objecttype, object, Privacyenum::PUBLIC).collect(&:user_id)
								    	@users = @users + current_user.followers.collect(&:id)
								    end  
								elsif (objectfor.event.privacy==Privacyenum::PRIVATE)
							  		if (objectfor.privacy==Privacyenum::PUBLIC)
							  			@users = objectfor.event.eventdetails.collect(&:user_id)
								    else(objectfor.privacy==Privacyenum::PRIVATE)
								    	@users = objectfor.activitydetails.collect(&:user_id)
								    end 
								end
					else
			  			@users = active_community_user_ids
			 	    	@users = getActivitynotificationUserssettings(@users, objecttype, object, Privacyenum::PUBLIC).collect(&:user_id)
				    	@users = @users + current_user.followers.collect(&:id)
			  		end
		  when Objecttypeenum::COMMENT then
		  	@users = objectfor.comments.collect(&:user_id)
		  	@users = @users + object.user_id
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
		#debugger
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

	def createNotificationSettings(cu_id)
        @notifications_settings = Activitynotificationsetting.new
        @notifications_settings.user_id = current_user.id
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

	def deleteNotificationSettings(cu_id)
		Activitynotificationsetting.where("community_id = ? AND user_id = ?", cu_id, current_user.id).first.destroy
	end

	def build_body_text(objecttype, object, objectfortype, objectfor, action)
		body_text = ""
		case objecttype
		  when Objecttypeenum::COMUNITY then
		  		if action == Notificationtypeenum::CREATED
		  			body_text = "The ComUnity '" + @community.name + "' was created by "+ current_user.name
		  		elsif action == Notificationtypeenum::UPDATED
		  			body_text = "The ComUnity '" + @community.name + "' was updated by "+ current_user.name
		  		elsif action == Notificationtypeenum::JOINED
		  			body_text = objectfor.name + "has joined the ComUnity '" + @community.name + "'."
		  		elsif action == Notificationtypeenum::REQUESTED
		  			body_text = objectfor.name + "has requested to join the ComUnity '" + @community.name  + "'."
		  		elsif action == Notificationtypeenum::ACCEPTED
		  			body_text = "The request to join the ComUnity '" + @community.name  + "' has been accepted."
		  		elsif action == Uc_enum::INVITED
		  			body_text = "The moderator of the ComUnity '" + @community.name  + "' has requested to join the community."
		  		elsif action == Uc_enum::ADD_MODERATOR
		  			body_text = "You now moderator for the ComUnity '" + @community.name  + "'."
		  		end
		  when Objecttypeenum::EVENT then
		  when Objecttypeenum::ACTIVITY then
		  when Objecttypeenum::PHOTO then
		  when Objecttypeenum::ALBUM then
		  when Objecttypeenum::GROUP then
		  when Objecttypeenum::POST then
		  when Objecttypeenum::COMMENT then
		  when Objecttypeenum::USER then
		  else
		end	
	end

	def build_href(objecttype, object, objectfortype, objectfor, action)
        href = ""
        case objecttype
		  when Objecttypeenum::COMUNITY then
		  		href = "/communities/"+ @community.id.to_s	
		  when Objecttypeenum::EVENT then
		  when Objecttypeenum::ACTIVITY then
		  when Objecttypeenum::PHOTO then
		  when Objecttypeenum::ALBUM then
		  when Objecttypeenum::GROUP then
		  when Objecttypeenum::POST then
		  when Objecttypeenum::COMMENT then
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
		  when Objecttypeenum::ACTIVITY then
		  when Objecttypeenum::PHOTO then
		  when Objecttypeenum::ALBUM then
		  when Objecttypeenum::GROUP then
		  when Objecttypeenum::POST then
		  when Objecttypeenum::COMMENT then
		  when Objecttypeenum::USER then
		  else
		end	
	end
end
