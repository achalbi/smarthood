class Grouppost < ActiveRecord::Base
  attr_accessible :post_id, :group_id

  belongs_to :group
  belongs_to :post

  validates :group_id, presence: true
  validates :post_id, presence: true


end
