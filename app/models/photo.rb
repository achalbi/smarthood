class Photo < ActiveRecord::Base
  attr_accessible :post_id, :pic, :user_id
  
  belongs_to :post
  belongs_to :user
  mount_uploader :pic, PhotoUploader

  has_many :photoalbums, dependent: :destroy
  has_many :albums, :through => :photoalbums
#  has_attached_file :pic,  :url =>
#"/images/photos/:id/:style_:basename.:extension", :path =>
#":rails_root/public/images/photos/:id/:style_:basename.:extension"

 # validates_attachment_content_type :pic, :content_type =>
#'image/jpeg', :message => "has to be in jpeg format"


  #,
  #:storage => :s3,
  #:s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
  #:path => ":attachment/:id/:style.:extension",
  #:bucket => 'yourbucket'

end
