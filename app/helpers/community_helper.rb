module CommunityHelper
=begin
	require 'xmpp4r_facebook'

	def fb_message(sender_uid, receiver_uid, message_body, message_subject)
		sender_chat_id = "-#{sender_uid}@chat.facebook.com"
		receiver_chat_id = "-#{receiver_uid}@chat.facebook.com"

		jabber_message = Jabber::Message.new(receiver_chat_id, message_body)
		jabber_message.subject = message_subject

		client = Jabber::Client.new(Jabber::JID.new(sender_chat_id))
		client.connect
		client.auth_sasl(Jabber::SASL::XFacebookPlatform.new(client,
			ENV.fetch('FACEBOOK_APP_ID'), session['fb_access_token'],
			ENV.fetch('FACEBOOK_SECRET')), nil)
		client.send(jabber_message)
		client.close
	end
=end

def protected?(community)
  unless community.privacy == Privacyenum::PROTECTED && !community.usercommunities.where("user_id = ?  AND is_admin = ?", current_user.id, true ).exists?
    return true
  else
    return false
  end
end

def active?(community)
  if community.id == active_community.id
    return true
  else
    return false
  end
end

end
