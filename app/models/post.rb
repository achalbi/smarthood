class Post < ActiveRecord::Base
  attr_accessible :content, :user_id, :photo, :photo_file_name, :photo_content_type, :photo_file_size, :photo_updated_at, :photos_attributes, :pic


  belongs_to :user
  has_many :groupposts, dependent: :destroy
  has_many :groups, :through => :groupposts

  has_many :photos, dependent: :destroy
  accepts_nested_attributes_for :photos, :allow_destroy => true


  has_many :activityposts, dependent: :destroy
  has_many :activities, :through => :activityposts

  
  has_many :comments

  validates :content, presence: true
  validates :user_id, presence: true

  default_scope order: 'posts.created_at DESC'

end
