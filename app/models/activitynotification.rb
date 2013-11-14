class Activitynotification < ActiveRecord::Base
  attr_accessible :Activitynotificationtype, :body_html, :body_text, :href, :is_hidden, :is_unread, :objecttype, :recepient_id, :sender_id, :pic_url

  belongs_to :recepient, class_name: "User"
  belongs_to :sender, class_name: "User"
end

