class Comment < ActiveRecord::Base
  attr_accessible :content, :user_id, :post_id

  belongs_to :user
  
  belongs_to :post

  validates :content, presence: true
  validates :user_id, presence: true
end
