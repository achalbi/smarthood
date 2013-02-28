# == Schema Information
#
# Table name: authentications
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  provider     :string(255)
#  uid          :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Authentication < ActiveRecord::Base
  attr_accessible :provider, :uid, :user_id
  belongs_to :user
  
  
  def self.find_with_omniauth(auth)
    find_by_provider_and_uid(auth['provider'], auth['uid'])
  end

  def self.create_with_omniauth(auth)
    create(uid: auth['uid'], provider: auth['provider']) # and other data you might want from the auth hash
  end
end


