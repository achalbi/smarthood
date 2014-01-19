class BuysellItem < ActiveRecord::Base
  attr_accessible :address_attributes, :buysell_item_subcategory_id, :currency, :description, :name, :notes, :price, :privacy, :item_type, :user_id, :contact_no, :condition, :photos, :communities

    belongs_to :user
    belongs_to :address
    accepts_nested_attributes_for :address, :allow_destroy => true
    
    belongs_to :buysell_item_subcategory

    has_many :buysell_item_photos, dependent: :destroy
	has_many :photos, :through => :buysell_item_photos

	has_many :posts, :as => :postable

	has_many :buysell_item_communities, dependent: :destroy
	has_many :communities, :through => :buysell_item_communities
end
