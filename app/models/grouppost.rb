class Grouppost < ActiveRecord::Base
  attr_accessible :post_id, :user_group_id

  belongs_to :user_group
  belongs_to :post

  validates :user_group_id, presence: true
  validates :post_id, presence: true


end
