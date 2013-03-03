class Photoalbum < ActiveRecord::Base
  attr_accessible :album_id, :photo_id

  belongs_to :album
  belongs_to :photo

  validates :album_id, presence: true
  validates :photo_id, presence: true
end
