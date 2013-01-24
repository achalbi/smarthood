class Group < ActiveRecord::Base
  belongs_to :User
  attr_accessible :description, :name, :privacy, :User_id

  has_many :user_groups, dependent: :destroy
  has_many :users, :through => :user_groups
end
