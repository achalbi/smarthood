class BuysellItemSubcategory < ActiveRecord::Base
  attr_accessible :description, :name, :buysell_item_category_id
  attr_accessor :buysell_item_category_id 

  has_one :buysell_item_category_subcategory, dependent: :destroy
  has_one :buysell_item_category, :through => :buysell_item_category_subcategory

  validates :name,  presence: true, length: { maximum: 50 },
                    uniqueness: { case_sensitive: false }
end
