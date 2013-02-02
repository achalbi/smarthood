class Post < ActiveRecord::Base
  attr_accessible :content, :user_id

  belongs_to :user
  has_many :groupposts, dependent: :destroy
  has_many :groups, :through => :groupposts

  
  has_many :comments

  validates :content, presence: true
  validates :user_id, presence: true

  default_scope order: 'posts.created_at DESC'

end
