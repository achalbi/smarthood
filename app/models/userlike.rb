class Userlike < ActiveRecord::Base
  attr_accessible :likeable_id, :likeable_type, :user_id

  belongs_to :likeable, :polymorphic => true
  belongs_to :user
end
