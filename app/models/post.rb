class Post < ActiveRecord::Base
  attr_accessible :content, :user_id

  belongs_to :user
  has_many :groupposts, dependent: :destroy
  has_many :user_groups, :through => :groupposts


end
