class SConcern < ActiveRecord::Base
  attr_accessible :content, :status

  has_one :post, :as => :postable, :dependent => :destroy

  has_many :albums, :as => :albumable
  
end
