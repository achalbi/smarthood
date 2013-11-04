module ActivitynotificationsHelper

	def createNotification(user_id,objecttype,notificationtype, body_html, body_text, href )
	    @notification = Notification.new
	    @notification.sender_id = current_user.id
	    @notification.recepient_id = user_id
	    @notification.objecttype = objecttype
	    @notification.notificationtype = notificationtype
	    @notification.is_unread = false
	    @notification.is_hidden = false
	    @notification.body_html = body_html
	    @notification.body_text = body_text
	    @notification.href = href
	    @notification.save
	        
	end
end
