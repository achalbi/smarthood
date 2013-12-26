class Album < ActiveRecord::Base
  attr_accessible :cover_photo_id, :description, :privacy, :title, :type, :user_id, :photos

  belongs_to :albumable, :polymorphic => true
  belongs_to :user

  has_many :posts, :as => :postable
  has_many :photoalbums, dependent: :destroy
  has_many :photos, :through => :photoalbums

  validates :title,  presence: true

 
end
