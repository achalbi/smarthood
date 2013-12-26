class UserInfo < ActiveRecord::Base
  attr_accessible :app_url, :current_city, :dob, :education, :first_name, :gender, :home_town, :last_name, :middle_name, :mobile, :relationship_status, :sn_link, :website, :work
  belongs_to :user
end
